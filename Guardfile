guard 'rspec', :version => 2, :cli => '-f doc' do
  watch(%r{lib/(.+)\.rb})      { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{spec/.+_spec\.rb})
  watch('spec/spec_helper.rb') { "spec" }
end

guard 'test', :runner => 'fastfail' do
  watch(%r{lib/(.+)\.rb})      { |m| "test/#{m[1]}_test.rb" }
  watch(%r{test/.+_test\.rb})
  watch('test/test_helper.rb') { "test" }
end
