require "application_system_test_case"

class KioskTest < ApplicationSystemTestCase
    test "Check the kiosk page" do
        tournament = tournaments(:live_data_kq25)

        visit tournament_kiosk_url(tournament.slug)

        assert_selector "th", exact_text: "Rank"
        assert_selector "th", exact_text: "Scene"
        assert_selector "th", exact_text: "Score"

        page.all("tbody tr").each.with_index(1) do |tr, row|
            scene_score = scene_scores("live_data_kq25_#{row}")

            tr.all("td").each_with_index do |td, i|
                case i
                    when 0
                        assert_equal scene_score.rank.to_s, td.text
                    when 1
                        assert_equal scene_score.name, td.text
                    when 2
                        assert_equal scene_score.score.to_s, td.text
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
