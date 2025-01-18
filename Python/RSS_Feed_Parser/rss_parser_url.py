from argparse import ArgumentParser
from typing import List, Optional, Sequence
from xml.etree import ElementTree as ET
import requests
import json


class UnhandledException(Exception):
    pass

channel_tag_to_stdout_dict = {'title': 'Feed: ',
                            'link': 'Link: ',
                            'lastBuildDate': 'Last Build Date: ',
                            'pubDate': 'Publish Date: ',
                            'language': 'Language: ',
                            'category': 'Categories: ',
                            'managinEditor': 'Editor: ',
                            'description': 'Description: '}
item_tag_to_stdout_dict = {'title': 'Title: ',
                            'author': 'Author: ',
                            'pubDate': 'Published: ',
                            'link': 'Link: ',
                            'category': 'Categories: ',
                            'description': ''}

def rss_parser(
    xml: str,
    limit: Optional[int] = None,
    json: bool = False,
) -> List[str]:
    """
    RSS parser.

    Args:
        xml: XML document as a string.
        limit: Number of the news to return. if None, returns all news.
        json: If True, format output as JSON.

    Returns:
        List of strings.
        Which then can be printed to stdout or written to file as a separate lines.

    Examples:
        >>> xml = '<rss><channel><title>Some RSS Channel</title><link>https://some.rss.com</link><description>Some RSS Channel</description></channel></rss>'
        >>> rss_parser(xml)
        ["Feed: Some RSS Channel",
        "Link: https://some.rss.com"]
        >>> print("\\n".join(rss_parser(xmls)))
        Feed: Some RSS Channel
        Link: https://some.rss.com
    """
    rss_list = []
    rss_dict = {}

    xml_root = ET.fromstring(xml)

    for channel_tag_key, channel_out_value in channel_tag_to_stdout_dict.items():
        if channel_tag_key == 'category':
            xml_several_tags_appender(xml_root[0], rss_list, rss_dict, channel_tag_key, channel_out_value, channel_flag=True)
        else:
            xml_one_tag_appender(xml_root[0], rss_list, rss_dict, channel_tag_key, channel_out_value)
    
    items = item_parser(xml_root[0], item_tag_to_stdout_dict, rss_list, rss_dict, limit)

    if items:
        rss_dict['items'] = items

    if json is True:
        return encode_json(rss_dict)
    else:
        return rss_list

def xml_one_tag_appender(root, app_list, app_dict, tag_name, out_tag_name):
    '''
    Appends xml tag with modified console output tag name to app_list and creates item of app_dict for future json creation usage
    '''
    try:
        tag_text = root.find(tag_name).text
        app_list.append(f'{out_tag_name}{tag_text}')
        app_dict[tag_name] = tag_text
    except:
        pass

def xml_several_tags_appender(root, app_list, app_dict, tag_name, out_tag_name, channel_flag):
    '''
    Created specially for 'category' tag parsing
    Appends several xml tags with modified console output tag name to app_list and creates item of app_dict for future json creation usage
    In case of channel 'category' tags creates string output
    In case of items 'category' tags creates list output (primarly for better json representation)
    channel_flag: deternines if 'category' tag parsed for channel or items
    '''
    try: 
        tag_memory_list = root.findall(tag_name)
        tag_string = ''
        tag_list = []

        if channel_flag is True:
            if tag_memory_list == []:
                tag_output = ''
            for elem in tag_memory_list:
                tag_string += ', ' + elem.text
                tag_output = tag_string[2:] + ''
            app_list.append(f'{out_tag_name}{tag_output}')
        else:
            for elem in tag_memory_list:
                tag_list.append(elem.text)
                tag_output = tag_list
            app_list.append(f"{out_tag_name}{', '.join(tag_output)}")
        app_dict[tag_name] = tag_output
    except:
        pass

def item_parser(root, items_tags_outs_dict, app_list, app_dict, items_limit):
    '''
    Going inside items xml tags and parses it one by one to app_list
    Creates item_list_of_dicts and creates item of app_dict with these lists for further json creation usage
    '''
    channel_items = root.findall('item')

    if len(channel_items) == 0:
        return []

    if items_limit is None:
        items_limit == len(channel_items) - 1
    item_list_of_dicts = []

    for counter, current_item in enumerate(channel_items):
        item_dict = {}
        item_list = []
        app_list.append('') # used for adding an empty line between channel and items in console output
        for item_tag_key, item_out_value in items_tags_outs_dict.items():
            if item_tag_key == 'category':
                xml_several_tags_appender(current_item, item_list, item_dict, item_tag_key, item_out_value, channel_flag=False)
            else:
                xml_one_tag_appender(current_item, item_list, item_dict, item_tag_key, item_out_value)
        if counter == items_limit:
            break
        else:
            for elem in item_list:
                app_list.append(elem)
            item_list_of_dicts.append(item_dict)
            app_dict['items'] = item_list_of_dicts
    return item_list_of_dicts

def encode_json(result_rss_dict):
    '''
    Creates json file
    '''
    with open ('json_rss_feed.json', 'w', encoding='utf-8') as file:
        json.dump(result_rss_dict, file, indent=4)
    return [json.dumps(result_rss_dict)]

def main(argv: Optional[Sequence] = None):
    """
    The main function of your task.
    """
    parser = ArgumentParser(
        prog="rss_reader",
        description="Pure Python command-line RSS reader.",
    )
    parser.add_argument("source", help="RSS URL", type=str, nargs="?")
    parser.add_argument(
        "--json", help="Print result as JSON in stdout", action="store_true"
    )
    parser.add_argument(
        "--limit", help="Limit news topics if this parameter provided", type=int
    )

    args = parser.parse_args(argv)
    xml = requests.get(args.source).text

    try:
        main_result = rss_parser(xml, args.limit, args.json)
        print("\n".join(main_result))
        return 0
    except Exception as e:
        raise UnhandledException(e)


if __name__ == "__main__":
    main()
