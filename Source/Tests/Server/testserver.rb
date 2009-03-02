require 'rubygems'
require 'sinatra'
require 'sequel'
require 'json'
require 'faker'
require 'pp'
require 'xmlsimple'
require File.join(File.dirname(__FILE__), 'lib/authorization')

# Stupid hack so XmlSimple can use symbolized keys
class Symbol
  def [](*args)
    to_s[*args]
  end
end

# connect to an in-memory database
DB = Sequel.sqlite unless self.class.const_defined?('DB')


begin
  DB.schema(:people)
rescue
  # setup a people table
  DB.create_table :people do
    primary_key :id
    column :name, :text
    column :email, :text
    column :bio, :text
    column :address, :text
    column :telephone, :text
    column :created_at, :date
  end
end

# simple person model
class Person < Sequel::Model
  validates_presence_of :name, :email, :address
  
  def self.respond(params)
    #edit or create
    if params[:id]
      person = self.find(params[:id])
    else
      person = self.new
    end
    data = {} #JSON.parse(params)
    if person.update(data)
      {:status => 200, :name => person.name}
    else
      {:status => 500}
    end
  end
end

# create some records using Faker
10.times do
  Person.create({
    :name => Faker::Name.name,
    :email => Faker::Internet.email,
    :address => Faker::Address.street_address,
    :telephone => Faker::PhoneNumber.phone_number,
    :bio => Faker::Lorem.paragraph,
    :created_at => Time.now
  })
end

# Set every request to JSON
before do
  pp request.env
  def xml?
    request.env['CONTENT_TYPE'] == "application/xml"
  end
  # 
  def json?
    request.env['CONTENT_TYPE'] == "application/json"
  end
  
  if xml?
    content_type 'application/xml'
  elsif json?
    content_type 'application/json'
  end
end

#GET /status/500 returns the given status code
get '/status/:code' do
  status params[:code].to_i
end

get '/search' do
  Person.filter('id < ?', params[:limit]).collect { |p| p.values }.to_json
end

#GET /people returns all posts as json
get '/people' do
  people = Person.all.collect { |p| p.values }
  if json?
    people.to_json
  elsif xml?
    XmlSimple.xml_out(people, 'noattr' => 'yes', 'rootname' => 'people')
  end
end
 
#GET /person/1 returns that post as json
get '/person/:id' do
  Person.find(params[:id]).values.to_json
end
 
#PUT /person/1 update that puts with json
put '/person/:id' do
  person = Person.find(params[:id])
  data = JSON.parse(request.body.read)
  status 200 if person.update(data)
end
 
#POST /post body with data field set to JSON: { "title": "test", "body": "body test" }
post '/person' do
  data = JSON.parse(request.body.read)
  if p = Person.create(data)
    status 201
    p.values.to_json
  end
end
 
#DELETE /post/1 deletes post
delete '/person/:id' do
  person = Person.find(params[:id])
  status 200 if person.destroy
end

include Sinatra::Authorization
#BASIC AUTH
get '/auth' do
  login_required
  Person.first.values.to_json
end

def authorize(username, password)
  username == "user" && password = "test"
end

def authorization_realm
  "HTTPRiot Basic Auth Testser"
end