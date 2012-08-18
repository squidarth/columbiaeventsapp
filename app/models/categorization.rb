class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :event

  validates :event_id,    :presence => true, :uniqueness => { :scope => :category_id }
  validates :category_id, :presence => true, :uniqueness => { :scope => :event_id }

  delegate :name, to: :category

  acts_as_api
  api_accessible :public do |t|
    t.add :category
  end

  def self.categorize_event_by_keywords(event)
    if not event.description.presence
      return
    end
    category_keywords.each do |category_name, keywords|
      if not keywords.empty? and not event.description.downcase.scan(/#{keywords.join('|')}/).empty?
        category = Category.find_or_create_by_name category_name
        Categorization.create event: event, category: category
      end
    end
  end

  protected

  def self.category_keywords
    {
      'Academic'          => [],
      'Arts'              => [],
      'Career Networking' => ['cce', 'career', 'law', 'banking', 'medicine', 'premed', 'pre-med', 'pre-law', 'prelaw','cce', 'application', 'goldman', 'mckinsey', 'jp morgan', 'merill lynch', 'ubs'],
      'Community Service' => ['giving', 'service','charity', 'outreach'],
      'Cultural'          => ['cultural', 'chinese', 'taiwanese', 'muslim', 'indian', 'pakistani', 'indonesian', 'asian', 'korean', 'mexican', 'african', 'bso', 'zamana'],
      'Fraternities'      => ['pike', 'sigep', 'frat', 'fraternity', 'greek life', 'sorority', 'sigma kai','sigma nu'],
      'Free Food'         => ['free food'],
      'Music'             => [],
      'NYC Event'         => [],
      'Politics'          => ['politics', 'activism', 'democrats', 'republicans', 'debate', 'mitt romney', 'george bush', 'obama'],
      'Special Interest'  => ['adi', 'mun'],
      'Sports'            => ['sports', 'football', 'rowing', 'basketball', 'swimming', 'volleyball', 'fencing', 'archery', 'lacrosse', 'golf', 'cross country','soccer', 'skiing', 'ski', 'softball', 'baseball', 'wrestling', 'tennis', 'track', 'compete', 'dartmouth'],
      'Student Council'   => ['student council', 'ccsc', 'esc'],
      'Theater'           => ['theater', 'miller', 'shakespeare', 'oedipus', 'perform']
    }
  end
end
