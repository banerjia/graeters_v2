class OtherAttribute < ApplicationRecord
  belongs_to :attributable, polymorphic: true
end
