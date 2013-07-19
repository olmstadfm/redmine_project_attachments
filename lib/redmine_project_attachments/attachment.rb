module ProjectAttachmentsPlugin
  module AttachmentPatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable


        scope :time_period, lambda {|q, field|
          today = Date.today
          if q.present? && field.present?
            {:conditions =>
              (case q
               when "yesterday"
                 ["#{field} BETWEEN ? AND ?",
                  2.days.ago,
                  1.day.ago]
               when "today"
                 ["#{field} BETWEEN ? AND ?",
                  1.day.ago,
                  1.day.from_now]
               when "last_week"
                 ["#{field} BETWEEN ? AND ?",
                  1.week.ago - today.wday.days,
                  1.week.ago - today.wday.days + 1.week]
               when "this_week"
                 ["#{field} BETWEEN ? AND ?",
                  1.week.from_now - today.wday.days - 1.week,
                  1.week.from_now - today.wday.days]
               when "last_month"
                 ["#{field} BETWEEN ? AND ?",
                  1.month.ago - today.day.days,
                  1.month.ago - today.day.days + 1.month]
               when "this_month"
                 ["#{field} BETWEEN ? AND ?",
                  1.month.from_now - today.day.days - 1.month,
                  1.month.from_now - today.day.days]
               when "last_year"
                 ["#{field} BETWEEN ? AND ?",
                  1.year.ago - today.yday.days,
                  1.year.ago - today.yday.days + 1.year]
               when "this_year"
                 ["#{field} BETWEEN ? AND ?",
                  1.year.from_now - today.yday.days - 1.year,
                  1.year.from_now - today.yday.days]
               else
                 {}
               end)
            }
          end
        }

      end

    end

    module ClassMethods

    end

    module InstanceMethods
    end
  end
end
