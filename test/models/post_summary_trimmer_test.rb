require 'test_helper'

class PostSummaryTrimmerTest < ActiveSupport::TestCase
  setup do
    @trimmer = PostSummaryTrimmer.new(posts(:published))
  end

  test "#perform" do
    trimmed_summary = @trimmer.perform

    assert_equal '''<h2>Tinguamus fatifero haerent ut deserta sequitur laetabile</h2><p>Lorem markdownum ignibus es forma; inque urbis et inperfectus scelerum causa
miserabile limenque pervenit. Undas dum, vidit huic tolerare, in it’s feret pro
natamque, hoc Latonia prementem gramine!</p><pre><code>number_services(guid);
alignment += sshText;
backsideZipPage(pixel, realNavigationApp * active + gif);
var smb_sector_null = grepPlagiarism + swappable_tiff(miniRestoreVlog) -
        monochrome(17, domain_overwrite + zebibyte_mysql_kilobit,
        ipvDviTouchscreen);
</code></pre>''', trimmed_summary
  end

  test "#perform with error" do
    fake_phantom = Object.new
    def fake_phantom.inline(_)
      return "*** SOMETHING WENT WRONG ***\nTypeError"
    end

    assert_raises(PostSummaryTrimmer::JSError, "TypeError") {
      @trimmer.perform(fake_phantom)
    }
  end
end
