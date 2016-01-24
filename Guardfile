guard :minitest, spring: true do
  watch(%r{^test/(.*)\/?(.*)\.rb$})
  watch(%r{^app/models\/?(.*)\.rb$})     { 'test' }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
end
