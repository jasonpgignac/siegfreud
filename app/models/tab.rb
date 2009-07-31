class Tab < ActiveRecord::Base
  belongs_to :tabset;
  belongs_to :content_server;
  acts_as_list :scope => :tabset;
  has_one :tabset_active_in, :class_name => "Tabset", :foreign_key => :active_tab_id;
          
  def delete
    if self.active?
      tabset.switch_to_next_tab;
    end
    super
  end
  
  def title
    self.content.short_name();
  end
  def active?
    return (tabset.active_tab.id == self.id);
  end
  def content=(content_item)
    self.content_id = content_item.id
    self.content_type = content_item.class.to_s
    return 0;
  end
  def content
    content_class = self.content_type.camelize.constantize
    content = content_class.find(self.content_id);
  end
  
  def destroy
    if (self.active?)
      self.tabset.switch_to_next_tab;
    end
    super;
  end
  
end


