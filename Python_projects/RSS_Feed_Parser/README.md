# RSS Feed Parser
This is a pet Python project for parsing RSS feed of a web-site to print out following attributes of the feed or write them into JSON file:
* channel attributes:
    * title as 'Feed'
    * link as 'Link'
    * lastBuildDate as 'Last Build Date'
    * pubDate as 'Publish Date'
    * language as 'Language'
    * category as 'Categories'
    * managinEditor as 'Editor'
    * description as 'Description'
* item attributes:
    * title as 'Title'
    * author as 'Author'
    * pubdate as 'Published'
    * link as 'Link'
    * category as 'Categories'
    * description as ''

In case the attribute is missing in RSS Feed or vice-versa, nothing is posted or written ito json file.

Following optional flags are added to control the parsing:
* --limit (limits the number of item attributes parsed)
* --json (if present, then output is written as JSON file and JSON output format, if absent then not written as JSON and standard output format)

example of the terminal command to run the script:
python .\rss_parser_url.py "https://news.yahoo.com/rss" --limit 3 --json
