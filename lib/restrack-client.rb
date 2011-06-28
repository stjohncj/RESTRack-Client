require 'rubygems'
require 'mime/types'
require 'net/http'
require 'json'
require 'xmlsimple'

module RESTRack
  class Client

    def initialize(uri, format=:JSON)
      @uri = URI.parse(uri) unless uri.is_a? URI
      @path = ''
      @format = format
    end

    def method_missing(resource_name, *args)
      @path << '/' + resource_name.to_s
      @path << '/' + args.join('/') if args.length > 0
      self
    end

    def get
      request = Net::HTTP::Get.new(@path)
      response = send request
      parse response
    end

    def delete
      request = Net::HTTP::Delete.new(@path)
      response = send request
      parse response
    end

    def post(data=nil)
      request = Net::HTTP::Post.new(@path, {'Content-Type' => content_type })
      request.body = prepare data unless data.nil?
      response = send request
      parse response
    end

    def put(data=nil)
      request = Net::HTTP::Put.new(@path, {'Content-Type' => content_type })
      request.body = prepare data unless data.nil?
      response = send request
      parse response
    end

    private
    def content_type
      RESTRack.mime_type_for(@format).to_s
    end

    def prepare(data)
      case @format
      when :JSON
        data = data.to_json
      when :XML
        data = XmlSimple.xml_out(data, 'AttrPrefix' => true, 'XmlDeclaration' => true, 'NoIndent' => true)
      when :YAML
        data = YAML.dump(data)
      when :TEXT
        data = data.to_s
      end
      data
    end

    def send(request)
      @path = ''
      response = Net::HTTP.start(@uri.host, @uri.port) { |http| http.request(request) }
    end

    def parse(response)
      mime_type = MIME::Type.new( response.content_type )#response['content-type'] )
      if mime_type.like?( RESTRack.mime_type_for( :JSON ) )
        return JSON.parse( response.body )
      elsif mime_type.like?( RESTRack.mime_type_for( :XML ) )
        return XmlSimple.xml_in( response.body, 'ForceArray' => false )
      else
        return response.body
      end
    end
  end
end

module RESTRack
  def self.mime_type_for(format)
    MIME::Types.type_for(format.to_s.downcase)[0]
  end
end
MIME::Types['text/plain'][0].extensions << 'text'
MIME::Types.index_extensions( MIME::Types['text/plain'][0] )
