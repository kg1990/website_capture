class UrlCapture

  include MongoMapper::Document

  # key <name>, <type>
  set_collection_name 'url_captures'
  set_database_name 'youhaosuda'

  key :url, String, :required => true
  key :siteid, String
  key :themeid, Integer
  key :image_data, String
  timestamps!
  
end
