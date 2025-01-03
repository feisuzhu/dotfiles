((string
  (string_content) @injection.content)
  (#lua-match? @injection.content "^%s*-- SQL")
  (#set! injection.language "sql"))
