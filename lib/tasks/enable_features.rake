# lib/tasks/enable_features.rake
namespace :custom do
  desc 'Enables all available features for the first account'
  task enable_all_features: :environment do
    puts '--> Starting task to enable all features...'

    account = Account.first
    unless account
      puts '--> Error: No accounts found in the database.'
      next
    end

    puts "--> Found account: #{account.name} (ID: #{account.id})"

    # Get all feature names from the YML file, filtering out any nil or blank names
    all_feature_names = Featurable::FEATURE_LIST.map { |f| f['name'] }.compact.reject(&:blank?)

    if all_feature_names.empty?
      puts '--> Error: Could not find any feature names to enable.'
      next
    end

    puts "--> Found #{all_feature_names.count} features to enable. Attempting to apply..."

    begin
      account.enable_features!(*all_feature_names)
      puts '--> Successfully enabled all features for the account.'
    rescue => e
      puts "--> An error occurred while enabling features: #{e.message}"
    end
  end
end
