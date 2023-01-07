;; -*- lexical-binding: t -*-
(org-babel-load-file "~/.emacs.d/configuration.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("/home/d/OrgDocuments/personal/yoga.org" "/home/d/OrgDocuments/personal/Books/Complete-MandA/complete-m-and-a.org" "/home/d/OrgDocuments/personal/Books/Leading-Lean/LeadingLean.org" "/home/d/OrgDocuments/personal/Books/Private-Equity-Playbook/private-quity-playbook.org" "/home/d/OrgDocuments/personal/Books/Project-to-Product/project-to-product.org" "/home/d/OrgDocuments/personal/Books/ShapeUp/ShapeUp.org" "/home/d/OrgDocuments/personal/Books/first-90-days/the-first-90-days.org" "/home/d/OrgDocuments/personal/journals/2020/2020-02.org" "/home/d/OrgDocuments/personal/journals/2020/2020-03.org" "/home/d/OrgDocuments/personal/journals/2020/2020-04.org" "/home/d/OrgDocuments/personal/journals/2020/2020-05.org" "/home/d/OrgDocuments/personal/journals/2020/2020-06.org" "/home/d/OrgDocuments/personal/journals/2020/2020-07.org" "/home/d/OrgDocuments/personal/journals/2020/2020-08.org" "/home/d/OrgDocuments/personal/journals/2020/2020-09.org" "/home/d/OrgDocuments/personal/journals/2020/2020-10.org" "/home/d/OrgDocuments/personal/journals/2020/2020-11.org" "/home/d/OrgDocuments/personal/journals/2020/2020-12.org" "/home/d/OrgDocuments/personal/journals/2020/2020.org" "/home/d/OrgDocuments/personal/journals/2021/2021-01.org" "/home/d/OrgDocuments/personal/journals/2021/2021-02.org" "/home/d/OrgDocuments/personal/journals/2021/2021-03.org" "/home/d/OrgDocuments/personal/journals/2021/2021-04.org" "/home/d/OrgDocuments/personal/journals/2021/2021-05.org" "/home/d/OrgDocuments/personal/journals/2021/2021-06.org" "/home/d/OrgDocuments/personal/journals/2021/2021-07.org" "/home/d/OrgDocuments/personal/journals/2021/2021-08.org" "/home/d/OrgDocuments/personal/journals/2021/2021-09.org" "/home/d/OrgDocuments/personal/journals/2021/2021-10.org" "/home/d/OrgDocuments/personal/journals/2021/2021-11.org" "/home/d/OrgDocuments/personal/journals/2021/2021-12.org" "/home/d/OrgDocuments/personal/journals/2021/2021.org" "/home/d/OrgDocuments/personal/journals/2022/2022-01.org" "/home/d/OrgDocuments/personal/journals/2022/2022-02.org" "/home/d/OrgDocuments/personal/journals/2022/2022-03.org" "/home/d/OrgDocuments/personal/journals/2022/2022-04.org" "/home/d/OrgDocuments/personal/journals/2022/2022-05.org" "/home/d/OrgDocuments/personal/journals/2022/2022-06.org" "/home/d/OrgDocuments/personal/journals/2022/2022-07.org" "/home/d/OrgDocuments/personal/journals/2022/2022-08.org" "/home/d/OrgDocuments/personal/journals/2022/2022-09.org" "/home/d/OrgDocuments/personal/journals/2022/2022-10.org" "/home/d/OrgDocuments/personal/journals/2022/2022-11.org" "/home/d/OrgDocuments/personal/journals/2022/2022-12.org" "/home/d/OrgDocuments/personal/journals/2022/2022.org" "/home/d/OrgDocuments/personal/journals/2023/2023-01.org" "/home/d/OrgDocuments/personal/journals/2023/2023.org" "/home/d/OrgDocuments/personal/mandarin/mandarin1.org" "/home/d/OrgDocuments/personal/ocean/ocean.org" "/home/d/OrgDocuments/personal/ocean/ocean_letter.org" "/home/d/OrgDocuments/personal/python/python.org" "/home/d/OrgDocuments/personal/resume/resume.org" "/home/d/OrgDocuments/personal/roam/2021-06-02--14-50-04Z--carbon_capture_in_trees.org" "/home/d/OrgDocuments/personal/roam/2021-06-09--03-11-57Z--elliot_brown_watches.org" "/home/d/OrgDocuments/personal/roam/2021-06-09--03-15-35Z--holy_trinity.org" "/home/d/OrgDocuments/personal/roam/2021-06-09--13-20-48Z--computer_vision_and_physics.org" "/home/d/OrgDocuments/personal/roam/2021-06-11--01-45-42Z--metamask.org" "/home/d/OrgDocuments/personal/roam/2021-06-11--01-47-11Z--decentraland.org" "/home/d/OrgDocuments/personal/roam/2021-06-11--04-09-41Z--mckinsey_product_model.org" "/home/d/OrgDocuments/personal/roam/2021-06-13--20-35-52Z--things_i_missed.org" "/home/d/OrgDocuments/personal/roam/2021-06-15--02-50-37Z--garrick_watches.org" "/home/d/OrgDocuments/personal/roam/2021-06-28--00-17-29Z--pinion_watches.org" "/home/d/OrgDocuments/personal/roam/2021-06-28--00-28-16Z--rolex_model_guide.org" "/home/d/OrgDocuments/personal/roam/2021-06-30--15-02-37Z--emacs_and_wsl.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-21-57Z--10_machine_learning_questions.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-29-14Z--automation_effects.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-42-58Z--business_books.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-51-35Z--innovation_pipeline.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-55-36Z--micro_front_end_architectures.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-58-11Z--mashroom_server.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-59-02Z--stenciljs.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--14-59-37Z--casbin.org" "/home/d/OrgDocuments/personal/roam/2021-07-01--16-24-58Z--century_link.org" "/home/d/OrgDocuments/personal/roam/2021-07-05--22-22-46Z--gsk_digital_twins.org" "/home/d/OrgDocuments/personal/roam/2021-07-06--18-12-40Z--armin_strom_watches.org" "/home/d/OrgDocuments/personal/roam/2021-07-11--21-39-43Z--accutron_dna.org" "/home/d/OrgDocuments/personal/roam/2021-07-11--21-41-00Z--rolex_datejust.org" "/home/d/OrgDocuments/personal/roam/2021-07-11--21-41-57Z--bulova_spaceview.org" "/home/d/OrgDocuments/personal/roam/2021-07-11--21-42-47Z--hermes_h08.org" "/home/d/OrgDocuments/personal/roam/2021-07-14--01-06-10Z--mindfullness_and_i_or_we.org" "/home/d/OrgDocuments/personal/roam/2021-07-15--02-03-26Z--atelier_de_chronometrie.org" "/home/d/OrgDocuments/personal/roam/2021-07-15--02-06-50Z--moritz_grossman.org" "/home/d/OrgDocuments/personal/roam/2021-07-15--02-11-04Z--alchemists.org" "/home/d/OrgDocuments/personal/roam/2021-07-15--02-13-22Z--andreas_strehler.org" "/home/d/OrgDocuments/personal/roam/2021-08-01--18-38-35Z--emacs_like_an_instrument.org" "/home/d/OrgDocuments/personal/roam/2021-08-07--14-35-29Z--gshock_mrg_g2000r_1a.org" "/home/d/OrgDocuments/personal/roam/2021-08-08--18-13-36Z--apartment_network.org" "/home/d/OrgDocuments/personal/roam/2021-08-16--01-37-05Z--intro_to_digital_twins.org" "/home/d/OrgDocuments/personal/roam/2021-08-16--22-48-34Z--leader_leverage.org" "/home/d/OrgDocuments/personal/roam/2021-08-16--22-49-28Z--national_association_of_boards.org" "/home/d/OrgDocuments/personal/roam/2021-08-23--13-24-28Z--pdf_studio_pro_license.org" "/home/d/OrgDocuments/personal/roam/2021-09-04--01-35-56Z--ressence_watches.org" "/home/d/OrgDocuments/personal/roam/2021-09-19--16-33-30Z--vanguart_black_hole_tourbillion.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-48-20Z--abbey.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-49-23Z--a_t_o_t_l_w.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-50-36Z--aviation.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-08Z--bermuda_rum_swizzle.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-10Z--bijou.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-10Z--caipirinha.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-11Z--casino.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-12Z--clover_club.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-13Z--cobbler_s_dream.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-14Z--cosmopolitan.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-15Z--elderflower_sour.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-16Z--elegant_orange.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-16Z--especial_day.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-17Z--fernet_old_fashioned.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-18Z--friday_sunrise.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-19Z--gin_gin_mule.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-20Z--green_glass.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-20Z--jasmine.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-21Z--kaffir_fling.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-22Z--floridita_daiquiri.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-22Z--la_luna.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-23Z--last_word.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-24Z--leave_it_to_me_2.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-25Z--lemon_drop.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-25Z--lokoki.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-26Z--lusty_lady.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-27Z--macdaddy.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-28Z--margarhita.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-28Z--marisol.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-29Z--martinez.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-32Z--mr_richter.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-43Z--my_bitter_ex.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-44Z--negroni.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-45Z--orange_fairy.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-46Z--peach_spiced_old_fashioned.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-46Z--pear_necessity.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-48Z--ramos_gin_fizz.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-49Z--romanza.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-50Z--rye_whisper.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-50Z--san_pedro.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-51Z--sea_salt_foam.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-52Z--side_car.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-52Z--silver_monk_tequila.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-54Z--simple_syrup_recipes.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-55Z--the_elegant_spice.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-56Z--tokyo_cooler.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-57Z--ueno_san.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-58Z--whiskey_sour.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-51-59Z--white_russian.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-52-00Z--persimmon_cocktail.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-56-12Z--bangkok_cocktail_bars.org" "/home/d/OrgDocuments/personal/roam/2021-09-25--13-56-46Z--tokyo_cocktail_bars.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-11-31Z--alley_lease.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-18-09Z--colin_next_of_kin.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-18-51Z--colin_pension.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-20-05Z--colin_will.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-21-14Z--colin_banks.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-22-28Z--colin_group_pension.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-24-57Z--nationwide_international.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-25-53Z--colin_accounts.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-29-49Z--deloitte_mathematics.org" "/home/d/OrgDocuments/personal/roam/2021-09-28--03-33-14Z--los_angeles_bars_and_restaurants.org" "/home/d/OrgDocuments/personal/roam/2021-10-04--04-41-39Z--linux_notes.org" "/home/d/OrgDocuments/personal/roam/2021-10-04--04-42-45Z--windows_notes.org" "/home/d/OrgDocuments/personal/roam/2021-10-04--04-43-37Z--sway_notes.org" "/home/d/OrgDocuments/personal/roam/2021-10-08--20-25-14Z--perpetual_calendars.org" "/home/d/OrgDocuments/personal/roam/2021-10-11--01-43-22Z--twittering_mode.org" "/home/d/OrgDocuments/personal/roam/2021-10-11--02-35-45Z--bitcoin_ponzi.org" "/home/d/OrgDocuments/personal/roam/2021-10-11--13-38-18Z--watch_collection.org" "/home/d/OrgDocuments/personal/roam/2021-10-11--13-40-36Z--watch_research.org" "/home/d/OrgDocuments/personal/roam/2021-10-14--15-17-19Z--force_org_id_locations.org" "/home/d/OrgDocuments/personal/roam/2021-10-14--16-35-37Z--jim_herd.org" "/home/d/OrgDocuments/personal/roam/2021-10-14--16-35-50Z--tom_taft.org" "/home/d/OrgDocuments/personal/roam/2021-10-15--21-39-47Z--artya_tourbillion.org" "/home/d/OrgDocuments/personal/roam/2021-10-16--13-50-13Z--ikigai.org" "/home/d/OrgDocuments/personal/roam/2021-10-16--20-40-25Z--andrew_yurko.org" "/home/d/OrgDocuments/personal/roam/2021-10-16--20-42-31Z--tuck_richards.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--02-08-00Z--farer.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--14-35-18Z--eth_101.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--14-35-51Z--centralized_exchanges.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--14-36-36Z--decentralized_exchanges_dex.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--14-37-08Z--wallets.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--14-43-41Z--daaps.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--20-51-46Z--crypto_security_and_web3.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--21-00-45Z--private_key.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--21-08-15Z--defi.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--21-10-30Z--cryptosteel.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--21-12-23Z--coldwallet.org" "/home/d/OrgDocuments/personal/roam/2021-10-17--21-15-15Z--seed_phrase.org" "/home/d/OrgDocuments/personal/roam/2021-10-19--03-29-23Z--solidity.org" "/home/d/OrgDocuments/personal/roam/2021-10-19--03-30-11Z--hardhat.org" "/home/d/OrgDocuments/personal/roam/2021-10-22--00-09-34Z--lux_ledger.org" "/home/d/OrgDocuments/personal/roam/2021-10-27--02-56-53Z--capital_in_the_twenty_first_century.org" "/home/d/OrgDocuments/personal/roam/2021-10-27--02-58-00Z--desert_one.org" "/home/d/OrgDocuments/personal/roam/2021-10-27--02-59-04Z--tommaso.org" "/home/d/OrgDocuments/personal/roam/2021-10-27--03-00-11Z--gangs_of_wasseypur.org" "/home/d/OrgDocuments/personal/roam/2021-10-27--13-06-10Z--come_for_the_assets_stay_for_the_experience.org" "/home/d/OrgDocuments/personal/roam/2021-10-28--17-38-59Z--emacs_on_ubuntu.org" "/home/d/OrgDocuments/personal/roam/2021-10-30--14-08-35Z--art_and_crypto_merging.org" "/home/d/OrgDocuments/personal/roam/2021-10-31--13-52-09Z--microaquire.org" "/home/d/OrgDocuments/personal/roam/2021-10-31--23-21-05Z--mbsync.org" "/home/d/OrgDocuments/personal/roam/2021-11-02--04-08-33Z--bright_moments.org" "/home/d/OrgDocuments/personal/roam/2021-11-04--13-18-23Z--market_definition.org" "/home/d/OrgDocuments/personal/roam/2021-11-06--23-24-04Z--metaverse_by_donald.org" "/home/d/OrgDocuments/personal/roam/2021-11-25--16-41-22Z--montres_kf.org" "/home/d/OrgDocuments/personal/roam/2021-11-26--09-00-14Z--akrivia.org" "/home/d/OrgDocuments/personal/roam/2021-11-29--09-41-10Z--hpm_emails.org" "/home/d/OrgDocuments/personal/roam/2021-12-04--14-26-02Z--christmas_shopping.org" "/home/d/OrgDocuments/personal/roam/2021-12-04--15-14-24Z--trilobe.org" "/home/d/OrgDocuments/personal/roam/2021-12-05--13-29-35Z--seven_layers_of_the_metaverse.org" "/home/d/OrgDocuments/personal/roam/2021-12-05--13-33-32Z--metaverse_tam.org" "/home/d/OrgDocuments/personal/roam/2021-12-05--13-39-38Z--meta_s_metaverse.org" "/home/d/OrgDocuments/personal/roam/2021-12-05--13-48-33Z--metaverse_platforms.org" "/home/d/OrgDocuments/personal/roam/2021-12-05--13-54-32Z--metaverse_categories.org" "/home/d/OrgDocuments/personal/roam/2021-12-09--22-58-02Z--grand_seiko_omiwatari.org" "/home/d/OrgDocuments/personal/roam/2021-12-11--20-39-32Z--ten_metaverse_business_models.org" "/home/d/OrgDocuments/personal/roam/2021-12-11--20-43-10Z--cryptovoxels.org" "/home/d/OrgDocuments/personal/roam/2021-12-14--00-44-27Z--datascience_classification.org" "/home/d/OrgDocuments/personal/roam/2021-12-15--00-04-01Z--2022_crypto_thesis.org" "/home/d/OrgDocuments/personal/roam/2021-12-15--02-17-59Z--eth_address.org" "/home/d/OrgDocuments/personal/roam/2021-12-15--02-27-32Z--the_block.org" "/home/d/OrgDocuments/personal/roam/2021-12-17--01-34-05Z--nft_project_idea.org" "/home/d/OrgDocuments/personal/roam/2021-12-19--15-20-11Z--adidas_metaverse.org" "/home/d/OrgDocuments/personal/roam/2021-12-20--22-03-20Z--business_of_fashion_video.org" "/home/d/OrgDocuments/personal/roam/2021-12-21--01-02-15Z--tezos_nft_marketplace.org" "/home/d/OrgDocuments/personal/roam/2021-12-24--00-00-45Z--nft_marketplaces.org" "/home/d/OrgDocuments/personal/roam/2021-12-29--05-17-53Z--scrt_transaction.org" "/home/d/OrgDocuments/personal/roam/2021-12-29--20-59-56Z--apache_parquet.org" "/home/d/OrgDocuments/personal/roam/2021-12-31--16-26-58Z--the_case_against_ctypto.org" "/home/d/OrgDocuments/personal/roam/2021-12-31--17-54-21Z--launch_consulting.org" "/home/d/OrgDocuments/personal/roam/2021-12-31--18-01-42Z--dressx.org" "/home/d/OrgDocuments/personal/roam/2021-12-31--18-03-11Z--bounteous.org" "/home/d/OrgDocuments/personal/roam/2021-12-31--18-09-26Z--hero_digital.org" "/home/d/OrgDocuments/personal/roam/20210601105932-angelus_watches.org" "/home/d/OrgDocuments/personal/roam/20210601110155-arnold_and_son.org" "/home/d/OrgDocuments/personal/roam/2022-01-05--03-09-00Z--space_companies.org" "/home/d/OrgDocuments/personal/roam/2022-01-09--22-12-09Z--touchcast.org" "/home/d/OrgDocuments/personal/roam/2022-01-09--22-23-28Z--accenture_global_digital_arena.org" "/home/d/OrgDocuments/personal/roam/2022-01-09--22-33-54Z--accenture_metaverse_speakers.org" "/home/d/OrgDocuments/personal/roam/2022-01-10--02-51-31Z--cardano.org" "/home/d/OrgDocuments/personal/roam/2022-01-12--14-04-44Z--crypto_tumbler.org" "/home/d/OrgDocuments/personal/roam/2022-01-14--04-51-50Z--scratch.org" "/home/d/OrgDocuments/personal/roam/2022-01-15--15-42-50Z--kelso_document_passwords.org" "/home/d/OrgDocuments/personal/roam/2022-01-18--02-32-24Z--sartory_billiard.org" "/home/d/OrgDocuments/personal/roam/2022-01-22--16-42-45Z--the_real_trolley_problem.org" "/home/d/OrgDocuments/personal/roam/2022-01-22--16-45-38Z--what_the_hell_are_nfts.org" "/home/d/OrgDocuments/personal/roam/2022-01-27--05-24-59Z--therapists.org" "/home/d/OrgDocuments/personal/roam/2022-01-29--15-07-47Z--web3_tech_architecture.org" "/home/d/OrgDocuments/personal/roam/2022-01-29--15-51-20Z--my_work_week.org" "/home/d/OrgDocuments/personal/roam/2022-01-30--01-07-10Z--crypto_cartoons.org" "/home/d/OrgDocuments/personal/roam/2022-02-06--21-04-16Z--ark_invest_report.org" "/home/d/OrgDocuments/personal/roam/2022-02-13--15-29-15Z--david_rosenthal_ee380_talk.org" "/home/d/OrgDocuments/personal/roam/2022-02-21--03-56-54Z--decentralized_identity_did.org" "/home/d/OrgDocuments/personal/roam/2022-02-25--04-51-35Z--nixie_clock.org" "/home/d/OrgDocuments/personal/roam/2022-03-03--14-22-37Z--deepdao.org" "/home/d/OrgDocuments/personal/roam/2022-03-03--14-42-58Z--asus_g14.org" "/home/d/OrgDocuments/personal/roam/2022-03-05--15-25-16Z--white_male_system.org" "/home/d/OrgDocuments/personal/roam/2022-03-05--15-34-03Z--jlc_master_thin_pereptual_enamel.org" "/home/d/OrgDocuments/personal/roam/2022-03-20--14-13-05Z--de_sci.org" "/home/d/OrgDocuments/personal/roam/2022-03-21--01-27-56Z--david_gerald_blockchain_deck.org" "/home/d/OrgDocuments/personal/roam/2022-03-22--13-25-28Z--orca_protocol.org" "/home/d/OrgDocuments/personal/roam/2022-03-26--13-50-12Z--krayon.org" "/home/d/OrgDocuments/personal/roam/2022-04-02--14-35-28Z--crypto_skeptics.org" "/home/d/OrgDocuments/personal/roam/2022-04-04--16-23-35Z--chicago_restaurants.org" "/home/d/OrgDocuments/personal/roam/2022-04-08--03-18-07Z--mychart.org" "/home/d/OrgDocuments/personal/roam/2022-04-10--13-08-01Z--build_muscle_naturally.org" "/home/d/OrgDocuments/personal/roam/2022-04-10--13-14-10Z--techno_fuedalism.org" "/home/d/OrgDocuments/personal/roam/2022-04-20--04-10-55Z--rudis_sylva.org" "/home/d/OrgDocuments/personal/roam/2022-04-24--13-54-26Z--seiko_prospex_1965_diver.org" "/home/d/OrgDocuments/personal/roam/2022-04-30--22-40-52Z--emacs_on_windows.org" "/home/d/OrgDocuments/personal/roam/2022-05-01--14-20-31Z--irr.org" "/home/d/OrgDocuments/personal/roam/2022-05-01--14-22-18Z--moic.org" "/home/d/OrgDocuments/personal/roam/2022-05-01--14-23-10Z--dpi.org" "/home/d/OrgDocuments/personal/roam/2022-05-01--14-39-05Z--questions_for_kelso.org" "/home/d/OrgDocuments/personal/roam/2022-05-24--01-37-39Z--skyward.org" "/home/d/OrgDocuments/personal/roam/2022-05-28--19-42-40Z--h20.org" "/home/d/OrgDocuments/personal/roam/2022-05-28--23-41-34Z--hyperbole_notes.org" "/home/d/OrgDocuments/personal/roam/2022-05-29--20-45-43Z--msys2_libraries.org" "/home/d/OrgDocuments/personal/roam/2022-06-05--03-00-36Z--sugess_tourbillon.org" "/home/d/OrgDocuments/personal/roam/2022-06-05--14-41-56Z--the_history_of_nfts.org" "/home/d/OrgDocuments/personal/roam/2022-06-06--00-58-53Z--symlinks_in_msys2.org" "/home/d/OrgDocuments/personal/roam/2022-06-06--01-39-44Z--metaverse_presentation.org" "/home/d/OrgDocuments/personal/roam/2022-06-14--00-25-47Z--kris_flyer.org" "/home/d/OrgDocuments/personal/roam/2022-06-18--13-59-02Z--fzf.org" "/home/d/OrgDocuments/personal/roam/2022-07-05--18-25-14Z--ansible.org" "/home/d/OrgDocuments/personal/roam/2022-07-06--01-45-00Z--singapore_restaurants.org" "/home/d/OrgDocuments/personal/roam/2022-07-06--03-30-57Z--cropx.org" "/home/d/OrgDocuments/personal/roam/2022-07-06--03-39-09Z--blockchain_hypothesis.org" "/home/d/OrgDocuments/personal/roam/2022-07-09--03-35-54Z--arkit_6_notes.org" "/home/d/OrgDocuments/personal/roam/2022-07-24--19-38-17Z--mckinsey_presentation_format.org" "/home/d/OrgDocuments/personal/roam/2022-07-25--01-01-54Z--firefox_notes.org" "/home/d/OrgDocuments/personal/roam/2022-08-03--15-03-29Z--cocktail_recipe_book.org" "/home/d/OrgDocuments/personal/roam/2022-08-05--03-25-42Z--averna_daiquiri.org" "/home/d/OrgDocuments/personal/roam/2022-08-05--13-18-58Z--stephen_diehl_zotero.org" "/home/d/OrgDocuments/personal/roam/2022-08-06--02-58-55Z--mephisto.org" "/home/d/OrgDocuments/personal/roam/2022-08-06--03-04-55Z--perfect.org" "/home/d/OrgDocuments/personal/roam/2022-08-06--03-10-09Z--ruby_booby.org" "/home/d/OrgDocuments/personal/roam/2022-08-09--19-03-10Z--synthing.org" "/home/d/OrgDocuments/personal/roam/2022-08-19--14-04-53Z--blockchain_when_to_use.org" "/home/d/OrgDocuments/personal/roam/2022-08-23--12-56-05Z--texlive.org" "/home/d/OrgDocuments/personal/roam/2022-08-23--22-57-38Z--rolex_appraisal.org" "/home/d/OrgDocuments/personal/roam/2022-08-27--15-35-40Z--hermes_volyna_leather_birkin_50_hac.org" "/home/d/OrgDocuments/personal/roam/2022-08-28--04-43-13Z--blockchain_legal_paper.org" "/home/d/OrgDocuments/personal/roam/2022-09-11--14-19-24Z--crypto_policy_symposium.org" "/home/d/OrgDocuments/personal/roam/2022-09-11--14-51-47Z--systemitizing_gtm_hiring.org" "/home/d/OrgDocuments/personal/roam/2022-09-13--13-28-07Z--cruch_culture.org" "/home/d/OrgDocuments/personal/roam/2022-09-17--14-01-00Z--synthetic_data.org" "/home/d/OrgDocuments/personal/roam/2022-09-17--14-30-08Z--rss.org" "/home/d/OrgDocuments/personal/roam/2022-09-18--13-36-05Z--probablistic_machine_learning.org" "/home/d/OrgDocuments/personal/roam/2022-09-18--23-06-51Z--monocole.org" "/home/d/OrgDocuments/personal/roam/2022-09-28--13-07-16Z--toy_stores.org" "/home/d/OrgDocuments/personal/roam/2022-10-06--01-06-27Z--screaming.org" "/home/d/OrgDocuments/personal/roam/2022-10-06--16-02-51Z--sf_restaurants.org" "/home/d/OrgDocuments/personal/roam/2022-10-08--14-00-19Z--ny_restaurants.org" "/home/d/OrgDocuments/personal/roam/2022-10-11--01-17-38Z--prescription.org" "/home/d/OrgDocuments/personal/roam/2022-10-13--03-23-28Z--puerto_rico.org" "/home/d/OrgDocuments/personal/roam/2022-10-14--13-55-15Z--venture_notes.org" "/home/d/OrgDocuments/personal/roam/2022-10-16--22-09-45Z--champagne.org" "/home/d/OrgDocuments/personal/roam/2022-10-18--01-55-48Z--nola_restaurants.org" "/home/d/OrgDocuments/personal/roam/2022-10-20--13-12-06Z--this_life_itself.org" "/home/d/OrgDocuments/personal/roam/2022-10-21--19-24-02Z--margin_debt.org" "/home/d/OrgDocuments/personal/roam/2022-10-22--04-20-05Z--singapore_cocktail_bars.org" "/home/d/OrgDocuments/personal/roam/2022-10-23--21-58-08Z--cannes_award.org" "/home/d/OrgDocuments/personal/roam/2022-10-30--14-09-21Z--maslow_hierarchy.org" "/home/d/OrgDocuments/personal/roam/2022-10-31--02-22-02Z--cocktail_ingredients.org" "/home/d/OrgDocuments/personal/roam/2022-11-05--22-32-11Z--casio_g_shock_gm_b2100gd.org" "/home/d/OrgDocuments/personal/roam/2022-11-07--16-32-18Z--mastodon.org" "/home/d/OrgDocuments/personal/roam/2022-11-08--03-16-50Z--freakonomics_change.org" "/home/d/OrgDocuments/personal/roam/2022-11-09--01-42-27Z--agenhor.org" "/home/d/OrgDocuments/personal/roam/2022-11-11--17-43-54Z--yagna.org" "/home/d/OrgDocuments/personal/roam/2022-11-11--21-01-11Z--yoga_asanas.org" "/home/d/OrgDocuments/personal/roam/2022-11-12--23-06-46Z--nerfstudio.org" "/home/d/OrgDocuments/personal/roam/2022-11-14--17-31-22Z--mckinsey_leads.org" "/home/d/OrgDocuments/personal/roam/2022-11-18--15-52-30Z--fedora_37_upgrade_instructions.org" "/home/d/OrgDocuments/personal/roam/2022-11-20--14-34-22Z--duckdb.org" "/home/d/OrgDocuments/personal/roam/2022-11-25--03-04-37Z--redmond_trip.org" "/home/d/OrgDocuments/personal/roam/2022-12-09--16-24-29Z--grand_seiko_green_birch.org" "/home/d/OrgDocuments/personal/roam/2022-12-10--20-36-27Z--lvmh_cdo.org" "/home/d/OrgDocuments/personal/roam/2022-12-15--01-07-20Z--interests_archive.org" "/home/d/OrgDocuments/personal/roam/2022-12-15--14-11-25Z--therapists_for_jamie.org" "/home/d/OrgDocuments/personal/roam/2022-12-22--16-55-44Z--lvmh_houses.org" "/home/d/OrgDocuments/personal/roam/2022-12-22--17-00-47Z--lvmh_annual_report.org" "/home/d/OrgDocuments/personal/roam/2022-12-26--00-22-38Z--lvmh_transition_plan.org" "/home/d/OrgDocuments/personal/wordpress/20210213-post2.org" "/home/d/OrgDocuments/personal/wordpress/20210307-horology.org" "/home/d/OrgDocuments/personal/wordpress/20210414-dawn-of-the-code-war.org" "/home/d/OrgDocuments/personal/wordpress/20210414-ethics.org" "/home/d/OrgDocuments/personal/wordpress/20210414-free-education.org" "/home/d/OrgDocuments/personal/wordpress/20210414-linux1.org" "/home/d/OrgDocuments/personal/wordpress/20210415-great-art.org" "/home/d/OrgDocuments/personal/wordpress/20210416-sms-hotmess.org" "/home/d/OrgDocuments/personal/wordpress/20210418-emacs.org" "/home/d/OrgDocuments/personal/wordpress/20210418-nice.org" "/home/d/OrgDocuments/personal/wordpress/20210418-swin-kids-movie.org" "/home/d/OrgDocuments/personal/wordpress/20210420-shaking-hands.org" "/home/d/OrgDocuments/personal/wordpress/20210428-american-sickness.org" "/home/d/OrgDocuments/personal/wordpress/20210428-rudy.org" "/home/d/OrgDocuments/personal/wordpress/20210501-no-social.org" "/home/d/OrgDocuments/personal/wordpress/20210505-fb-review.org" "/home/d/OrgDocuments/personal/wordpress/20210510-turbulent-twenties.org" "/home/d/OrgDocuments/personal/wordpress/20210511-gen-z.org" "/home/d/OrgDocuments/personal/wordpress/20210516-tom-jones.org" "/home/d/OrgDocuments/personal/wordpress/20210517-fedora.org" "/home/d/OrgDocuments/personal/wordpress/20210517-microsoft.org" "/home/d/OrgDocuments/personal/wordpress/20210519-spaceview2.org" "/home/d/OrgDocuments/personal/wordpress/20210528-experiment.org" "/home/d/OrgDocuments/personal/wordpress/20210603-traitors.org" "/home/d/OrgDocuments/personal/wordpress/20210613-donald.org" "/home/d/OrgDocuments/personal/wordpress/20210627-scottish-watches.org" "/home/d/OrgDocuments/personal/wordpress/20210807-olympics.org" "/home/d/OrgDocuments/personal/wordpress/20210828-fall.org" "/home/d/OrgDocuments/personal/wordpress/20210902-maui.org" "/home/d/OrgDocuments/personal/wordpress/20210908-mrg.org" "/home/d/OrgDocuments/personal/wordpress/20210913-nobody.org" "/home/d/OrgDocuments/personal/wordpress/20210919-1M.org" "/home/d/OrgDocuments/personal/wordpress/20211002-coup.org" "/home/d/OrgDocuments/personal/wordpress/20211104-fedora35.org" "/home/d/OrgDocuments/personal/wordpress/20211106-american-justice.org" "/home/d/OrgDocuments/personal/wordpress/20211123-return-home.org" "/home/d/OrgDocuments/personal/wordpress/20211129-leaving-scotland.org" "/home/d/OrgDocuments/personal/wordpress/20211211-experiment-part3.org" "/home/d/OrgDocuments/personal/wordpress/20211227-dont-look-up.org" "/home/d/OrgDocuments/personal/wordpress/20220101-year-in-review.org" "/home/d/OrgDocuments/personal/wordpress/20220122-omiwatari.org" "/home/d/OrgDocuments/personal/wordpress/20220306-yoga.org" "/home/d/OrgDocuments/personal/wordpress/20220326-1m.org" "/home/d/OrgDocuments/personal/wordpress/20220417-tesla.org" "/home/d/OrgDocuments/personal/wordpress/20220514-random-thoughts.org" "/home/d/OrgDocuments/personal/wordpress/20220701-experiment5.org" "/home/d/OrgDocuments/personal/wordpress/20220701-sugess-tourbillion.org" "/home/d/OrgDocuments/personal/wordpress/20220813-rule-of-law.org" "/home/d/OrgDocuments/personal/wordpress/20220820-flowof-bs.org" "/home/d/OrgDocuments/personal/wordpress/20221016-pixel.org" "/home/d/OrgDocuments/personal/wordpress/20221029-so-long-twitter.org" "/home/d/OrgDocuments/personal/wordpress/20221106-fedora37.org" "/home/d/OrgDocuments/personal/wordpress/20221106-twitter.org" "/home/d/OrgDocuments/personal/wordpress/20221111-gshock.org" "/home/d/OrgDocuments/personal/wordpress/20221210-byebyetwitter.org" "/home/d/OrgDocuments/personal/wordpress/21211012-sway.org" "/home/d/OrgDocuments/personal/wordpress/21211211-new-york.org" "/home/d/OrgDocuments/personal/wordpress/220507-experiment4.org" "/home/d/OrgDocuments/personal/.org2blog.org" "/home/d/OrgDocuments/personal/GTD.org" "/home/d/OrgDocuments/personal/books.org" "/home/d/OrgDocuments/personal/bsd405.org" "/home/d/OrgDocuments/personal/condo.org" "/home/d/OrgDocuments/personal/contacts.org" "/home/d/OrgDocuments/personal/emacs.org" "/home/d/OrgDocuments/personal/index.org" "/home/d/OrgDocuments/personal/job-hunting.org" "/home/d/OrgDocuments/personal/latex-template.org" "/home/d/OrgDocuments/personal/leadership.org" "/home/d/OrgDocuments/personal/living-will.org" "/home/d/OrgDocuments/personal/peloton.org" "/home/d/OrgDocuments/personal/quotes.org" "/home/d/OrgDocuments/personal/rss-feeds.org" "/home/d/OrgDocuments/personal/shopping.org" "/home/d/OrgDocuments/personal/taxes.org" "/home/d/OrgDocuments/personal/vespa.org" "/home/d/OrgDocuments/personal/kelso/kelso.org.gpg" "/home/d/OrgDocuments/personal/roam/2021-09-14--19-30-56Z--wells_fargo_routing_number.org.gpg" "/home/d/OrgDocuments/personal/roam/2022-06-14--00-44-17Z--us_passport.org.gpg" "/home/d/OrgDocuments/personal/roam/2022-06-14--00-45-09Z--uk_passport.org.gpg" "/home/d/OrgDocuments/personal/amps.org.gpg" "/home/d/OrgDocuments/personal/ledger.org.gpg" "/home/d/OrgDocuments/personal/metamask.org.gpg"))
 '(package-selected-packages
   '(org-roam-ui org-attach-screenshot auto-package-update default-text-scale yasnippet-snippets org-contrib org-superstar org-edna visual-fill-column calfw calfw-org org-present company-emoji flycheck-inline flycheck-title org-ql org-download eglot diminish counsel avy doc-toc markdown-mode deadgrep yaml-mode org-msg use-package-ensure-system-package posframe org2blog org-transclusion gnuplot git-timemachine elfeed-org doom-themes magit orderless projectile consult-org-roam marginalia pdf-tools mastodon pandoc use-package-hydra)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
