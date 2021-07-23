from crawler import run_crawler

key = "btgg"
search_terms = "龙珠"
page = 1
sort = ""

proxies = {"http": "http://127.0.0.1:9910", "https": "http://127.0.0.1:9910", }

if __name__ == '__main__':
    data = run_crawler(key, search_terms, page, sort)
    for d in data:
        print(d)
