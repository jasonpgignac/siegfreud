class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
	    t.string	:manufacturer
	    t.string	:title
	    t.string	:version
	    t.integer	:license_count		
	    t.boolean	:is_licensed  
    	t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
