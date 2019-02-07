require "application_system_test_case"

class KioskTest < ApplicationSystemTestCase
    test "Check the kiosk page" do
        tournament = tournaments(:live_data_kq25)

        visit tournament_kiosk_url(tournament.slug)

        within "table" do
            within "thead" do
                [ "Rank", "Scene", "Score" ].each do |text|
                    assert_selector "th", exact_text: text
                end
            end

            within "tbody" do
                tournament.scene_scores.rank_order.each.with_index(1) do |score, i|
                    within "tr:nth-child(#{i})" do
                        assert_selector "td:first-child", exact_text: score.rank.to_s
                        assert_selector "td:nth-child(2)", exact_text: score.name
                        assert_selector "td:nth-child(3)", exact_text: score.score.to_s
                    end
                end
            end
        end
    end

    test "Check meta refresh tags" do
        tag = "/html/head/meta[@http-equiv='refresh']"

        visit tournament_kiosk_url(tournaments(:live_data_kq25).slug)

        assert page.find(:xpath, tag, visible: false)

        visit tournament_kiosk_url(tournaments(:live_data_4teams).slug)

        assert_raises(Capybara::ElementNotFound) do
            page.find(:xpath, tag, visible: false)
        end
    end
end
