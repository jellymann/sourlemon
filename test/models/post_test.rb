require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "#slug_url" do
    assert_equal "/blog/2016/03/01/some-blog-post", posts(:published).slug_url
    assert_equal "/blog/2016/04/12/my-new-blog-post", posts(:unpublished).slug_url
  end

  test "#display_date" do
    assert_equal " 1 March 2016", posts(:published).display_date
    assert_equal "12 April 2016", posts(:unpublished).display_date
  end

  test "#short_display_date" do
    assert_equal " 1 Mar '16", posts(:published).short_display_date
    assert_equal "12 Apr '16", posts(:unpublished).short_display_date
  end

  test "#listing_display_date" do
    assert_equal " 1 Mar", posts(:published).listing_display_date
    assert_equal "12 Apr", posts(:unpublished).listing_display_date
  end

  test "#tags_csv" do
    assert_equal "foo, bar", posts(:published).tags_csv
    assert_equal "", posts(:unpublished).tags_csv
  end

  test "#tags_csv=" do
    posts(:unpublished).tags_csv = "qux,norf"

    assert_equal ["qux", "norf"], posts(:unpublished).tags
    assert_equal "qux, norf", posts(:unpublished).tags_csv
  end

  test "#generate_body_html" do
    assert_equal '''<h2>Tinguamus fatifero haerent ut deserta sequitur laetabile</h2>

<p>Lorem markdownum ignibus es forma; inque urbis et inperfectus scelerum causa
miserabile limenque pervenit. Undas dum, vidit huic tolerare, in feret pro
natamque, hoc Latonia prementem gramine!</p>
<pre class="highlight plaintext"><code>number_services(guid);
alignment += sshText;
backsideZipPage(pixel, realNavigationApp * active + gif);
var smb_sector_null = grepPlagiarism + swappable_tiff(miniRestoreVlog) -
        monochrome(17, domain_overwrite + zebibyte_mysql_kilobit,
        ipvDviTouchscreen);
</code></pre>

<h2>Dextro sub potitus petis tempusque anima</h2>

<p>Ore quod ferasque positasque parens aetherioque ordine et naides ab. Blanditias
nostro violabere tibi pendebant gaudia centum tandemque rediturum, Hippomenes
alta fuisset iubeas, cui densis, fit. Gutture omnes, curvos pectore mortua
venerisque pectoris algae est, quem deduxit et. Procul tamen sinistro se saepe
felicior, secernit capitisque regia. Aliquisque terrebant transformata nocte?</p>

<p>Ipse ripis murmure moverent; Hyantea submisit narrat. Amanti domui pulcherrime
quater sacra cursus in habebam dixerat per: desierant aestuat pictas cursu id.
Aequalis animos, cincta addit, est harenas sonuit?</p>
''', posts(:published).generate_body_html
  end

  test "#generate_summary_html" do
    assert_equal '''<h2>Tinguamus fatifero haerent ut deserta sequitur laetabile</h2><p>Lorem markdownum ignibus es forma; inque urbis et inperfectus scelerum causa
miserabile limenque pervenit. Undas dum, vidit huic tolerare, in feret pro
natamque, hoc Latonia prementem gramine!</p><pre><code>number_services(guid);
alignment += sshText;
backsideZipPage(pixel, realNavigationApp * active + gif);
var smb_sector_null = grepPlagiarism + swappable_tiff(miniRestoreVlog) -
        monochrome(17, domain_overwrite + zebibyte_mysql_kilobit,
        ipvDviTouchscreen);
</code></pre><h2>Dextro sub potitus petis tempusque anima</h2>
''', posts(:published).generate_summary_html
  end

  test ".published" do
    assert_equal [posts(:published)], Post.published
  end

  test ".unpublished" do
    assert_equal [posts(:unpublished)], Post.unpublished
  end
end
