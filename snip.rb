%w(rubygems sinatra dm-core dm-timestamps).each  { |lib| require lib}

get '/' do haml :index end

post '/' do
  @url = Url.first(:original => params[:original])
  @url = Url.create(:original => params[:original]) if @u.nil?
  haml :index
end

get '/:snipped' do redirect Url[params[:snipped].to_i(36)].original end

error do haml :index end

use_in_file_templates!

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root:root@localhost/snip')
class Url
  include DataMapper::Resource
  property  :id,          Serial
  property  :original,    String, :length => 255
  property  :created_at,  DateTime  
  def snipped() self.id.to_s(36) end  
end

__END__

@@ layout
!!! 1.1
%html
  %head
    %title Snip!
    %link{:rel => 'stylesheet', :href => 'http://www.w3.org/StyleSheets/Core/Modernist', :type => 'text/css'}  
  = yield

@@ index
%h1.title Snip!
- unless @url.nil?
  %code= @url.original
  snipped to 
  %a{:href => env['HTTP_REFERER'] + @url.snipped}
    = env['HTTP_REFERER'] + @url.snipped
#err.warning= env['sinatra.error']
%form{:method => 'post', :action => '/'}
  Snip this:
  %input{:type => 'text', :name => 'original', :size => '50'} 
  %input{:type => 'submit', :value => 'snip!'}
%small copyright &copy;
%a{:href => 'http://blog.saush.com'}
  Chang Sau Sheong