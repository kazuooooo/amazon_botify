require 'selenium-webdriver'
require 'pry'
class WebDriver
  include Singleton

  AMAZON_URL = 'https://www.amazon.com/'
  PRODUCT_URL = "https://#{ENV['AMAZON_BOT_DOMAIN']}/dp/"
  DRIVER     = :chrome

  attr_accessor :email, :password, :driver

  def initialize
    @email    = ENV['AMAZON_BOT_EMAIL']
    @password = ENV['AMAZON_BOT_PASSWORD']
    @driver   = Selenium::WebDriver.for DRIVER
  end

  def order(amazon_product_id, exec_order)
    begin

      go_to(AMAZON_URL)
      click('nav-link-accountList')
      login


      go_to(PRODUCT_URL + amazon_product_id.to_s)
      click('add-to-cart-button')
      click('hlb-ptc-btn-native')

      login

      click('placeYourOrder1') if exec_order
      return screenshot
    rescue => e
      return e.message
    end
  end

  private
  def go_to(url)
    driver.navigate.to url
  end

  def find(element_id)
    driver.find_element(:id, element_id)
  end

  def click(element_id)
    find(element_id).click
  end

  def input(element_id, value)
    find(element_id).send_keys(value)
  end

  def login
    input('ap_email', email)
    input('ap_password', password)
    click('signInSubmit')
  end

  def screenshot
    driver.save_screenshot('order.png')
  end

end
#
# func login(page *agouti.Page) {
#   page.Find('#ap_email').Fill(EMAIL)
#   page.Find('#ap_password').Fill(PASSWORD)
# }
# func (c WebDriver) Order(productId string) string {
#   // Declare Web Driver
#   agoutiDriver := agouti.PhantomJS()
#
#   agoutiDriver.Start()
#   defer agoutiDriver.Stop() // defer 延ばす、延期する
#     page, _ := agoutiDriver.NewPage()
#
#     // Login
#   // go to amazon top page
#   if err := page.Navigate('https://www.amazon.com/'); err != nil {
#       log.Fatalf('Navigate Error:%v', err)
#   }
#
#   // click sign in
#   if err := page.Find('#nav-link-accountList').Click(); err != nil {
#       log.Fatalf('Find Error:%v', err)
#   }
#   // input form
#   login(page)
#
#   // submit
#   page.Find('#signInSubmit').Click()
#
#   // Purchase
#   // go to product page
#   revel.INFO.Println('https://www.amazon.co.jp/dp/' + productId)
#   page.Navigate('https://www.amazon.co.jp/dp/' + productId)
#   page.Screenshot('b')
#
#   // add to cart
#   page.Find('#add-to-cart-button').Click()
#   // proceed to payment
#   page.Find('#hlb-ptc-btn-native').Click()
#
#   // ReLogin TODO: make DRY
#   // input form
#   login(page)
#   // submit
#   page.Find('#signInSubmit').Click()
#
#   // purchase
#   // page.FindByName('placeYourOrder1').Click()
#   page.Screenshot('Ordered.png')
#   return 'hoge'
