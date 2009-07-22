require 'rubygems'
require 'sinatra'
require 'sequel'
require 'json'
require 'faker'
require 'pp'
require 'builder'

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
  
  before_create do
    self.created_at = Time.now
  end
  
  def self.respond(params)
    #edit or create
    if params[:id]
      person = self.find("id = ?", params[:id])
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
if Person.count == 0
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
end


# Set every request to JSON
before do
  #pp request.env
  def xml?
    request.env['CONTENT_TYPE'] == "application/xml" || 
    request.env['REQUEST_URI'].split('.')[1] == 'xml'
  end
  # 
  def json?
    request.env['CONTENT_TYPE'] == "application/json" || 
    request.env['REQUEST_URI'].split('.')[1] == 'json'
  end
  
  def people_xml
    @people ||= Person.all.collect { |p| p.values}
    xml = Builder::XmlMarkup.new
    xml.people do
      @people.each do |per|
        xml.person do |p|
          p.name per[:name]
          p.email per[:email]
          p.address per[:address]
          p.telephone per[:telephone]
          p.bio per[:bio]
          p.created_at per[:created_at]
        end
      end
    end
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
get '/people*' do 
  pp request 
  @people = Person.all.collect { |p| p.values }
  
  if json?
    return @people.to_json
  elsif xml?
    return people_xml
  end
  
  erb :people
end
 
#GET /person/1 returns that post as json
get '/person/:id' do
  pp "GETTING PERSON"
  Person.find("id = ?", params[:id]).values.to_json
  #Person.find(params[:id]).values.to_json
end
 
#PUT /person/1 update that puts with json
put '/person/:id' do
  person = Person.find("id = ?", params[:id])
  pp person
  data = JSON.parse(request.body.read)
  if person.update(data)
    person.values.to_json
  end
end
 
#POST /post body with data field set to JSON: { "title": "test", "body": "body test" }
post '/person' do
  data = JSON.parse(request.body.read)
  if p = Person.create(data)
    status 201
    p.values.to_json
  end
end

post '/person/form-data' do
  if p = Person.create(params)
    status 201
  end
  
  redirect "/people"
end
 
#DELETE /post/1 deletes post
delete '/person/delete/:id' do
  person = Person.find("id = ?", params[:id])
  if person.destroy
    status 200 
    person.values.to_json
  end
end

# Timeout
get '/timeout' do
  sleep 40
end

include Sinatra::Authorization
#BASIC AUTH
get '/auth' do
  login_required
  Person.first.values.to_json
end

def authorize(username, password)
  username == "username@email.com" && password == "test"
end

def authorization_realm
  "HTTPRiot Basic Auth Testser"
end