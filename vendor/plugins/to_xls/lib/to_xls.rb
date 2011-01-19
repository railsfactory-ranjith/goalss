class Array
  def to_xls(options = {})
    output = '<?xml version="1.0" encoding="UTF-8"?><Workbook xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office"><Worksheet ss:Name="Sheet1"><Table>'

    if self.any?
      klass      = self.first.class
      attributes = self.first.attributes.keys.sort.map(&:to_sym)

      if options[:only]
        columns = Array(options[:only]) & attributes
      else
        columns = attributes - Array(options[:except])
      end

      columns += Array(options[:methods])

      if columns.any?
        unless options[:headers] == false
          output << "<Row>"
          columns.each { |column| output << "<Cell><Data ss:Type=\"String\">#{klass.human_attribute_name(column)}</Data></Cell>" }
          output << "</Row>"
        end    
  if columns.count==5
         output << "<Row>"
         output << "<Cell><Data ss:Type=\"String\">GroupName</Data></Cell>"
         output << "<Cell><Data ss:Type=\"String\">Owner</Data></Cell>"
         output << "<Cell><Data ss:Type=\"String\">Group_Leader</Data></Cell>"
         output << "<Cell><Data ss:Type=\"String\">Created_At</Data></Cell>"
         output << "<Cell><Data ss:Type=\"String\">Status</Data></Cell>"
        output << "</Row>"
        end
        self.each do |item|
          output << "<Row>"
           columns.each do |column|
            value = item.send(column)
              if column ==:created_at
                value=value.strftime("%m/%d/%Y")
              end
              if column ==:is_active
                value="Active" if value==true
                value="Suspended" if value==false
              end
            value=item.user.user_profile.first_name if value.class==Fixnum
            output << "<Cell><Data ss:Type=\"#{value.is_a?(Integer) ? 'Number' : 'String'}\">#{value}</Data></Cell>"
          end
          output << "</Row>"
        end
      end
    end
    output << '</Table></Worksheet></Workbook>'
end




 def to_register_user_xls(options = {})
    output = '<?xml version="1.0" encoding="UTF-8"?><Workbook xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office"><Worksheet ss:Name="Sheet1"><Table>'

    if self.any?
      klass      = self.first.class
      attributes = self.first.attributes.keys.sort.map(&:to_sym)

      if options[:only]
        columns = Array(options[:only]) & attributes
      else
        columns = attributes - Array(options[:except])
      end

      columns += Array(options[:methods])

      if columns.any?
        unless options[:headers] == false
          output << "<Row>"
          columns.each { |column| output << "<Cell><Data ss:Type=\"String\">#{klass.human_attribute_name(column)}</Data></Cell>" }
          output << "</Row>"
        end    
        self.each do |item|
          output << "<Row>"
           columns.each do |column|
            value = item.send(column)
          if column ==:created_at
           value=value.strftime("%m/%d/%Y")
           end
            output << "<Cell><Data ss:Type=\"#{value.is_a?(Integer) ? 'Number' : 'String'}\">#{value}</Data></Cell>"
          end
          output << "</Row>"
        end
      end
    end
    output << '</Table></Worksheet></Workbook>'
end





def to_invite_user_xls(options = {})
    output = '<?xml version="1.0" encoding="UTF-8"?><Workbook xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office"><Worksheet ss:Name="Sheet1"><Table>'

    if self.any?
      klass      = self.first.class
      attributes = self.first.attributes.keys.sort.map(&:to_sym)

      if options[:only]
        columns = Array(options[:only]) & attributes
      else
        columns = attributes - Array(options[:except])
      end

      columns += Array(options[:methods])

      if columns.any?
        unless options[:headers] == false
          output << "<Row>"
          columns.each { |column| output << "<Cell><Data ss:Type=\"String\">#{klass.human_attribute_name(column)}</Data></Cell>" }
          output << "</Row>"
        end    
        self.each do |item|
          output << "<Row>"
           a=columns.count
           columns.each do |column|
             value = item.send(column)
             if column ==:created_at
           value=value.strftime("%m/%d/%Y")
           end
            output << "<Cell><Data ss:Type=\"#{value.is_a?(Integer) ? 'Number' : 'String'}\">#{value}</Data></Cell>"
          end
          output << "</Row>"
        end
      end
    end
    output << '</Table></Worksheet></Workbook>'
  end





end
