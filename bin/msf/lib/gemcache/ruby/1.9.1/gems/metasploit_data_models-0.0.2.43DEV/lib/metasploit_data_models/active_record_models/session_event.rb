module MetasploitDataModels::ActiveRecordModels::SessionEvent
  def self.included(base)
    base.class_eval{

      belongs_to :session, :class_name => "Mdm::Session"
    }
  end
end
