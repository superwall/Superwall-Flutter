#!/usr/bin/env python3
"""Add a bullet to the "<subheading>" list of a CHANGELOG.md version section.

Usage: changelog-entry.py <changelog-path> <version> <subheading> <bullet> [replace-prefix]

If the top "## <version>" section already exists (a release is staged), the
bullet joins it, replacing a bullet that starts with replace-prefix if given
(so a second native bump in one release updates "Updates Android SDK to ..."
instead of listing both). Otherwise a new section is inserted above the newest.
"""
import re
import sys

VERSION_HEADING = re.compile(r"^##\s+\d+\.\d+\.\d+")


def main():
    path, version, subheading, bullet = sys.argv[1:5]
    replace_prefix = sys.argv[5] if len(sys.argv) > 5 else None
    with open(path, encoding="utf-8") as f:
        lines = f.read().split("\n")
    bullet_line = bullet if bullet.startswith("- ") else f"- {bullet}"

    top = next((i for i, l in enumerate(lines) if VERSION_HEADING.match(l)), len(lines))
    if top < len(lines) and lines[top].split()[1] == version:
        end = next(
            (i for i in range(top + 1, len(lines)) if VERSION_HEADING.match(lines[i])),
            len(lines),
        )
        if replace_prefix:
            stale = next(
                (i for i in range(top + 1, end) if lines[i].startswith(f"- {replace_prefix}")),
                None,
            )
            if stale is not None:
                lines[stale] = bullet_line
                return write(path, lines)
        sub = next((i for i in range(top + 1, end) if lines[i].strip() == subheading), None)
        if sub is None:
            lines[top + 1:top + 1] = ["", subheading, bullet_line]
        else:
            # Append after the last bullet of that sub-list.
            j = sub + 1
            while j < end and (lines[j].startswith("- ") or lines[j].startswith("  ")):
                j += 1
            lines.insert(j, bullet_line)
    else:
        lines[top:top] = [f"## {version}", "", subheading, bullet_line, ""]

    write(path, lines)


def write(path, lines):
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))


if __name__ == "__main__":
    main()
