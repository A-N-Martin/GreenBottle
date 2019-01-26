import csv
import time
from lxml import html
import requests
import unidecode

#The first scraper take each website link (listing conferences) from the csv file, go through the website and get the name of the authors
#and print these names into a new csv

#The second scraper takes the titles of the publications and print them into a new csv


def scraper(): #authors of conferences scraper
    link = open(r"C:\Users\Allmightyme\Desktop\website-link.csv")
    #link = open("website-link test.csv")
    csv_link = csv.reader(link)
    number = 0
    for row in csv_link:
                #section that grabs the data from the page
        if not row:
            continue #there should not be any empty row but in case there are, we skip it
        website = row[0]
        page = requests.get(website)
        tree = html.fromstring(page.content)
        names = tree.xpath('//span[@itemprop="author"]//span[@itemprop="name"]/text()') # always check that this corresponds to the website pattern
        title = tree.xpath('//title/text()')[0]
        unames = [unidecode.unidecode(x) for x in names] ## Unidecode normalizes the words (no accent, etc)
        number += 1
        print(f"we are at {number}/{len(csv_link)} !") ## Keeps track of how many we went through!
        #section that writes down the csv
        with open(title + '.csv', 'w') as f:
            for name in unames:
                f.write(name + '\n')
        time.sleep(2) #timesleep slows down process as there is no API, we don't want to ask to much of their server

def scraper2(): #title of papers scraper
    link = open(r"C:\Users\Allmightyme\Desktop\website-link.csv") ## Make sure it's the right localisation
    csv_link = csv.reader(link)
    number = 0
    for year in range(2015, 2019): #we want to create a csv file for each year with only the publication from that specific year
        publications = []
        link.seek(0) #reset the csv file to the first row for each year loop
        for row in csv_link: #grab website link from csv
            if not row:
                continue
            if str(year) in row[0]: #check if the website is for publications in the correct year
                website = row[0]
                page = requests.get(website)
                tree = html.fromstring(page.content)
                titles = tree.xpath('//span[@class="title"]/text()') # Check that it is the correct pattern for the website
                publications.append([unidecode.unidecode(x) for x in titles]) ## Unidecode normalizes the words (no accent, etc)
                number += 1
                print(f"we are at {year}! alternatively we are at conference number {number}") ## Keeps track of how website we went through
                time.sleep(2)
        with open(f"publication_for_{year}.csv", 'w') as f:
            for publication in publications:
                for single in publication: ## use a list of a list so we need two for loop
                    f.write(f"{single} \n")
