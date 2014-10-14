class AddCustomSlugToRefineryPagesTranslation < ActiveRecord::Migration
  def up
    if page_column_names.exclude?('custom_slug')
      add_column :refinery_page_translations, :custom_slug, :string
    end
  end

  def down
    if page_column_names.include?('custom_slug')
      remove_column :refinery_page_translations, :custom_slug
    end
  end

  private
  def page_column_names
    Refinery::Page::Translation.column_names.map(&:to_s)
  end
end
