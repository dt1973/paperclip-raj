class AddAttachmentIsProcessingToPhotos < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.column :attachment_is_processing, :boolean, default: false
    end
  end

  def self.down
    change_table :photos do |t|
      t.remove :attachment_is_processing
    end
  end
end
