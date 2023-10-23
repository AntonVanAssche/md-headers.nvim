Currently, the plugin is only able to recognize and extract headings that are constructed on a single line.
This is because the regular expression used to match headings only looks for the start and end tags of a heading element on the same line.

```markdown
# Heading
```

```html
<h1>Heading</h1>
```

Headings that span multiple lines, such as the one shown in the example below, will not be recognized by the plugin because the start and end tags are not on the same line.
This means that the regular expression will not match the heading, and it will not be included in the list of headings displayed in the popup window.

```html
<h1>
    Heading
</h1>
```

I understand that this limitation may be frustrating, and I apologize for the inconvenience.
Since this is a known and reported bug, please do not report it.
If reported, the issue will be closed and marked as `duplicate`.
This limitation is currently worked on, see pull request [#4](https://github.com/AntonVanAssche/md-headers.nvim/pull/4).
But I'm stuck on the implementation to detect html headings.
