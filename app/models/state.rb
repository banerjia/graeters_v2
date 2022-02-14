class State < ApplicationRecord

    def to_s
        self.state_code
    end
    
end
