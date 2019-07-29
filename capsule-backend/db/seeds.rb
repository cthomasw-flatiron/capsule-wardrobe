require 'pry'
require 'nokogiri'
require 'open-uri'

User.delete_all
Capsule.delete_all
Article.delete_all

#Create dummy users
user1 = User.create(username: 'Kargo', location: 'Seattle')
user2 = User.create(username: 'Mittens', location: 'Seattle')

#Create dummy capsules
capsule1 = Capsule.create(user_id: User.first.id, name: 'Spring 2019', season: 'Spring', style: 'Casual')
capsule2 = Capsule.create(user_id: User.first.id, name: 'Business Guru Outfits', season: 'Fall', style: 'Business Casual')
capsule3 = Capsule.create(user_id: User.second.id, name: 'Lookin\' Spiffy!', season: 'Summer', style: 'Athleisure')
capsule4 = Capsule.create(user_id: User.second.id, name: 'My Capsule Collection', season: 'Winter', style: 'Casual')

#Create dummy articles
# article1 = Article.create(category: 'shirt', image: 'https://image.uniqlo.com/UQ/ST3/WesternCommon/imagesgoods/418231/item/goods_25_418231.jpg?width=380')
# article2 = Article.create(category: 'shirt', image: 'https://image.uniqlo.com/UQ/ST3/WesternCommon/imagesgoods/419693/item/goods_02_419693.jpg?width=380')
# article3 = Article.create(category: 'shirt', image: 'https://image.uniqlo.com/UQ/ST3/WesternCommon/imagesgoods/418262/item/goods_59_418262.jpg?width=380')
# article4 = Article.create(category: 'dress', image: 'https://image.uniqlo.com/UQ/ST3/WesternCommon/imagesgoods/419860/item/goods_32_419860.jpg?width=380')
# article5 = Article.create(category: 'pants', image: 'https://image.uniqlo.com/UQ/ST3/WesternCommon/imagesgoods/421753/item/goods_02_421753.jpg?width=380')
# article6 = Article.create(category: 'pants', image: 'https://image.uniqlo.com/UQ/ST3/WesternCommon/imagesgoods/420346/item/goods_08_420346.jpg?width=380')
# article7 = Article.create(category: 'skirt', image: 'https://image.uniqlo.com/UQ/ST3/WesternCommon/imagesgoods/418885/item/goods_05_418885.jpg?width=380')


#Add articles to capsules
# capsule1.articles << [article1, article2, article4, article6, article7]
# capsule2.articles << [article2, article2, article4, article6, article7]
# capsule3.articles << [article3, article2, article5, article6, article7]
# capsule4.articles << [article3, article6, article4, article1, article7]



def scraper(url, category)

  output = {}

  doc = Nokogiri::HTML(open(url))
  product_tile = doc.css("div.product-tile-info")
  
  product_tile.each do |product|
    article_name = product.css("div.product-name a[title]").text.strip
    article_image = product.css("div.product-image a img")
    article_price = product.css("div.product-pricing span.product-sales-price").text
    output[article_name.to_sym] = {
      :article_image => article_image
    }
    article_image = output.values[0].values[0][0].values[0]
    Article.create(name: article_name, image: article_image, price: article_price, category: category)
  end
  output
end

# t-shirts and tops page
scraper('https://www.uniqlo.com/us/en/women/t-shirts-and-tops', 'top')

# shirts and blouses
scraper('https://www.uniqlo.com/us/en/women/shirts-and-blouses', 'top')

# all dresses and jumpsuits
scraper('https://www.uniqlo.com/us/en/women/dresses-and-jumpsuits', 'dress')

# skirts
scraper('https://www.uniqlo.com/us/en/women/skirts', 'skirt')

# pants
scraper('https://www.uniqlo.com/us/en/women/pants', 'pants')

# jeans
scraper('https://www.uniqlo.com/us/en/women/jeans', 'jeans')

# sweaters and cardis 
scraper('https://www.uniqlo.com/us/en/women/sweaters-and-cardigans', 'sweater')

