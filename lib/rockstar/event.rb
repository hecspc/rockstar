module Rockstar
  class Event < Base
    
    attr_accessor :eid, :title, :artists, :headliners, :start_date, :end_date,
                  :description, :attendance, :reviews, :tag, :url, :website, :tickets, 
                  :cancelled, :tags, :images, :venue, :info
    
    class << self
      def new_from_xml(xml, doc)
        puts xml
        e = Event.new(
          (xml).at(:id).inner_html
        )

        e.artists = []
        xml.search("/artists/artist").each {|a|
          e.artists << a.inner_html
        }

        e.headliners = []
        xml.search("/artists/headliner").each{|h|
          e.headliners <<  h.inner_html
        }
        e.title       = xml.search("/title").inner_html.strip
        e.start_date  = Base.parse_time(xml.search("/startDate").inner_html.strip)
        e.end_date    = Base.parse_time(xml.search("/endDate").inner_html.strip)
        e.description = xml.search("/description").inner_html.strip
        e.attendance  = xml.search("/attendance").inner_html.strip.to_i
        e.reviews     = xml.search("/reviews").inner_html.strip.to_i
        e.tag         = xml.search("/tag").inner_html.strip
        e.url         = xml.search("/url").inner_html.strip
        e.website     = xml.search("/website").inner_html.strip
        e.cancelled   = xml.search("/cancelled").inner_html.strip == 1

        e.tickets = []
        xml.search("/tickets/ticket").each{|t|
          e.tickets << t.inner_html
        }

        e.tags = []
        xml.search("/tags/tag").each{|t|
          e.tags << t.inner_html
        }

        e.images = {}
        xml.search('/image').each {|image|
          e.images[image['size']] = image.inner_html
        }

        e.venue = Venue.new_from_xml(xml.search('/venue'), doc) if xml.search('/venue')

        e
      end
      
      def get(id)
        doc           = Base.fetch_and_parse("event.getInfo", {:event => @eid})
        new_from_xml(doc/"event",doc)
      end
      
    end
    
    def initialize(id, o={})
      raise ArgumentError, "ID is required" if id.blank?
      @eid   = id
      options = {:include_info => false}.merge(o)
      load_info() if options[:include_info]
    end
    
    def load_info
      xml           = self.class.fetch_and_parse("event.getInfo", {:event => @eid})
      
      doc = xml/"event"
       @artists = []
        doc.search("/artists/artist").each {|a|
          @artists << a.inner_html
        }

        @headliners = []
        doc.search("/artists/headliner").each{|h|
          @headliners <<  h.inner_html
        }
        @title       = doc.search("/title").inner_html.strip
        @start_date  = Base.parse_time(doc.search("/startDate").inner_html.strip)
        @end_date    = Base.parse_time(doc.search("/endDate").inner_html.strip)
        @description = doc.search("/description").inner_html.strip
        @attendance  = doc.search("/attendance").inner_html.strip.to_i
        @reviews     = doc.search("/reviews").inner_html.strip.to_i
        @tag         = doc.search("/tag").inner_html.strip
        @url         = doc.search("/url").inner_html.strip
        @website     = doc.search("/website").inner_html.strip
        @cancelled   = doc.search("/cancelled").inner_html.strip == 1

        @tickets = []
        doc.search("/tickets/ticket").each{|t|
          @tickets << t.inner_html
        }

        @tags = []
        doc.search("/tags/tag").each{|t|
          @tags << t.inner_html
        }

        @images = {}
        doc.search('/image').each {|image|
          @images[image['size']] = image.inner_html
        }

       @venue = Venue.new_from_xml(doc.search('/venue'), doc) if doc.search('/venue')
    end
    
    def info
      get_instance("event.getInfo", :info, :event, {:event => @eid})
    end
    
    def image(which=:medium)
      which = which.to_s
      raise ArgumentError unless ['small', 'medium', 'large', 'extralarge', 'mega'].include?(which)  
      if (self.images.nil?)
        load_info
      end    
      self.images[which]
    end
  end
end

