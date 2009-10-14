require 'net/http'

require 'rubygems'
#I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2=true
require 'nokogiri'

class Lipsum 
  class AllTypes #:nodoc:
    def initialize(start)
      @amount = 1
      @what = nil
      @start = start
    end
    
    def [](n)
      @amount = n
      generate
      self
    end
    
    def to_s
      @lorem_ipsum.inner_text()
    end
    alias_method :to_string, :to_s
    
    def to_html
      self.to_s.split( /\n/ ).map{ |e| "<p>#{e}</p>\n" }.join()
    end
    
    private
    
    def generate
      opts = {'amount' => @amount, 'what' => @what}
      opts['start'] = 1 if @start
      response = Net::HTTP.post_form(URI.parse('http://lipsum.com/feed/xml'), opts)
      
      xml = Nokogiri::XML.parse(response.body)

      @lorem_ipsum = xml.xpath('//lipsum')
    end
  end
  
  class Paragraphs < AllTypes #:nodoc:
    def initialize(start)
      super(start)
      @what = "para"
    end
  end
  
  class Words < AllTypes #:nodoc:
    def initialize(start)
      super(start)
      @what = "words"
    end
  end
  
  class Bytes < AllTypes #:nodoc:
    def initialize(start)
      super(start)
      @what = "bytes"
    end
  end
  
  class Lists < AllTypes #:nodoc:
    def initialize(start)
      super(start)
      @what = "lists"
    end
    
    def to_s
      @lorem_ipsum.inner_text().split( /\n/ ).map{ |e| "- #{e}\n" }.join()
    end
    
    def to_html
      "<ul>\n" + @lorem_ipsum.inner_text().split( /\n/ ).map{ |e| "<li>#{e}</li>\n" }.join() + "</ul>"
    end
  end
  
  # If start is set to true, the placeholder text will start with 'Lorem ipsum 
  # dolor sit amet...'.
  def initialize(start = true)
    @start = start
    @lipsum = nil
  end
  
  # Create paragraphs
  def paragraphs
    @lipsum = Paragraphs.new(@start)
  end
  
  # Create words
  def words
    @lipsum = Words.new(@start)
  end
  
  # Create bytes
  def bytes
    @lipsum = Bytes.new(@start)
  end
  
  # Create lists
  def lists
    @lipsum = Lists.new(@start)
  end
  
  # Retrieve text
  def to_s
    @lipsum.to_s
  end
  alias_method :to_string, :to_s
  
  # Retrieve text in HTML format
  def to_html
    @lipsum.to_html
  end
  
  # method_missing allow you to use
  #
  #   Lipsum#paragraphs
  #   Lipsum#paragraphs!
  #   Lipsum#words
  #   Lipsum#words!
  #   Lipsum#bytes
  #   Lipsum#bytes!
  #   Lipsum#lists
  #   Lipsum#lists!
  def self.method_missing(id, *args)
    start = (id.id2name)[-1].chr == "!"
    method = (id.id2name).gsub( /!$/, "" )
    
    if ["paragraphs", "words", "bytes", "lists"].include?(method)
      return Lipsum.new(start).send(method)
    end
    raise NoMethodError, "undefined method `#{id.id2name}' for Lipsum:Class", caller
  end
end