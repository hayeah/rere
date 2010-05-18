class Thought < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  has_many :shared_thoughts
  
  def share(subject)
    self.shared_thoughts.create(:thought => self,
                                :subject => subject)
  end
end
