require "mongoid-sequence/version"
require "active_support/concern"

module Mongoid
  module Sequence
    extend ActiveSupport::Concern

    included do
      set_callback :create, :before, :set_sequence, unless: :sequence_already_set?
    end

    module ClassMethods
      attr_accessor :sequence_fields, :sequence_prefix

      def sequence(field, prefix = '')
        self.sequence_fields ||= []
        self.sequence_fields << field
        self.sequence_prefix = prefix
      end

      def inherit_sequence_from(klass)
        # Verify that we indeed inherit from said class
        unless self.ancestors.include? klass
          raise StandardError.new("You must also inherit from #{klass}")
        end

        # Initialize sequence inheritance
        unless self.respond_to? :sequence_inherited_from
          set_callback :create, :before, :set_inherited_sequence, :unless => :persisted?

          self.class.send :attr_accessor, :sequence_inherited_from
          self.sequence_inherited_from = []
        end

        self.sequence_inherited_from << klass

        self.send :define_method, :set_inherited_sequence do
          self.class.sequence_inherited_from.each do |klass|
            self.class.set_sequence_for_class(klass, self)
          end
        end
      end

      def set_sequence_for_class(klass, object)
        sequences = self.mongo_session['__sequences']
        prefix = klass.sequence_prefix.present? ? object.send(klass.sequence_prefix).to_s : ''
        klass.sequence_fields.each do |field|
          next_sequence = sequences.where(_id: "#{klass.name.underscore}_#{prefix}_#{field}").modify(
            { '$inc' => { seq: 1 } }, upsert: true, new: true
          )
          object[field] = next_sequence['seq']
        end if klass.sequence_fields
      end

      def sequence_already_set_for_class?(klass, object)
        klass.sequence_fields.each do |field|
          return false if object[field].nil?
        end if klass.sequence_fields
        true
      end
    end

    def set_sequence
      self.class.set_sequence_for_class(self.class, self)
    end

    def sequence_already_set?
      persisted? || self.class.sequence_already_set_for_class?(self.class, self)
    end
    
    def dup
      copy = super
      self.class.sequence_fields.each do |field|
        copy[field] = nil
      end if self.class.sequence_fields
      copy
    end
  end
end
