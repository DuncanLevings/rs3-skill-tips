"""Read rendered guide tables, expanding row/column spans before choosing fields."""

import re
from html.parser import HTMLParser

VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"}


class Node:
    def __init__(self, tag="root", attrs=(), parent=None):
        self.tag, self.attrs, self.parent, self.children = tag, dict(attrs), parent, []

    def walk(self):
        yield self
        for child in self.children:
            if isinstance(child, Node):
                yield from child.walk()

    def text(self):
        if self.tag in {"script", "style", "sup"} or "mw-editsection" in self.attrs.get("class", ""):
            return ""
        if self.tag == "img":
            alt = self.attrs.get("alt", "")
            if " image of " in alt:
                alt = alt.rsplit(" image of ", 1)[1]
            return alt + " "
        result = "".join(child.text() if isinstance(child, Node) else child for child in self.children)
        if self.tag in {"br", "p", "li", "div"}:
            result += " "
        return result


class Document(HTMLParser):
    def __init__(self, text):
        super().__init__(convert_charrefs=True)
        self.root = Node()
        self.current = self.root
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        node = Node(tag, attrs, self.current)
        self.current.children.append(node)
        if tag not in VOID:
            self.current = node

    def handle_endtag(self, tag):
        node = self.current
        while node.parent is not None:
            if node.tag == tag:
                self.current = node.parent
                return
            node = node.parent

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag not in VOID:
            self.handle_endtag(tag)

    def handle_data(self, data):
        self.current.children.append(data)


def clean(text):
    return re.sub(r"\s+", " ", text).strip()


def nearest(node, tag):
    parent = node.parent
    while parent is not None:
        if parent.tag == tag:
            return parent
        parent = parent.parent
    return None


def grid(table):
    pending, rows = {}, []
    for tr in table.walk():
        if tr.tag != "tr" or nearest(tr, "table") is not table:
            continue
        cells = [node for node in tr.children if isinstance(node, Node) and node.tag in {"td", "th"}]
        row, column = [], 0

        def carried():
            nonlocal column
            while column in pending:
                cell, remaining = pending.pop(column)
                row.append(cell)
                if remaining > 1:
                    pending[column] = (cell, remaining - 1)
                column += 1

        for cell in cells:
            carried()
            try:
                colspan = max(1, min(100, int(cell.attrs.get("colspan", 1))))
                rowspan = max(1, min(1000, int(cell.attrs.get("rowspan", 1))))
            except ValueError:
                colspan, rowspan = 1, 1
            for _ in range(colspan):
                row.append(cell)
                if rowspan > 1:
                    pending[column] = (cell, rowspan - 1)
                column += 1
        carried()
        if row:
            rows.append(row)
    return rows


def headings_and_tables(html):
    headings = []
    for node in Document(html).root.walk():
        if re.fullmatch(r"h[2-6]", node.tag):
            level = int(node.tag[1])
            headings = [(n, title) for n, title in headings if n < level]
            headings.append((level, clean(node.text())))
        elif node.tag == "table" and nearest(node, "table") is None:
            yield [title for _, title in headings], node
