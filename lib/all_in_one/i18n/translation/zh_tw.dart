import 'package:pokemon_sleep_tools/all_in_one/i18n/translation/zh_tw_game.dart';

Map<String, String> getZhTwTrText() {
  return {
    ...getZhTwTrGameText(),

    // region # Home
    't_main_menu': '主選單',
    't_sub_menu': '副選單',
    't_other_illustrated_books': '其他圖鑑',
    't_research_notes': '研究筆記',
    't_bag': '包包',
    't_map': '地圖',
    't_copyright_mark': '版權標記',
    't_source': '資料來源',
    't_data_import': '資料匯入',
    't_data_import_success': '資料匯入成功',
    't_data_import_failed': '資料匯入失敗',
    't_data_export': '資料匯出',
    't_data_export_success': '資料匯出成功',
    't_data_export_failed': '資料匯出失敗',
    't_export_data_to_download_folder': '匯出至下載資料夾',
    't_update_record': '更新紀錄',
    't_about': '關於',
    't_switch_language': '切換語言',
    // endregion

    // region # Common
    // region ## Sign
    't_slash': '／',
    't_separator': '、',
    // endregion
    // region ## Action
    't_continue_to_create_next_or_back_manually': '繼續新增下一筆，或手動返回上一頁',
    't_developing': '開發中',
    't_incomplete': '未完整',
    't_failed': '失敗',
    't_none': '無',
    't_confirm': '確定',
    't_cancel': '取消',
    't_delete': '刪除',
    't_create': '建立',
    't_edit': '編輯',
    't_create_success': '建立成功',
    't_create_failed': '建立失敗',
    't_update_success': '更新成功',
    't_update_failed': '更新失敗',
    't_leave_without_saving': '沒有儲存',
    't_leave_without_saving_content': '離開後將不會儲存，確定要離開嗎？',
    't_delete_someone_hint': '刪除「@someone」刪除後無法復原',
    // endregion
    // region ## Others
    't_name_and_nickname': '名字、暱稱',
    't_others': '其他',
    't_other_settings': '其他設定',
    't_simple': '簡易',
    't_details': '詳細',
    't_close': '關閉',
    't_ok': 'OK',
    't_reset': '重置',
    't_attributes': '屬性',
    't_categories': '種類',
    't_commonly_used': '常用',
    't_custom_name': '自訂名稱',
    't_basic_information': '基本資訊',
    't_snorlax_s_favorite_tree_fruit': '卡比獸喜歡的樹果',
    't_no_level_limit': '不限等級',
    't_discoverable_islands': '可發現島嶼',
    't_energy_integral': '能量積分',
    't_overall_rating': '總評價',
    't_upgrade': '提升等級',
    't_seconds': '秒',
    // endregion
    // endregion

    // region # Pokemon
    // region ## Common
    't_pokemon': '寶可夢',
    't_pokemon_box': '寶可夢盒',
    't_pokemon_illustrated_book': '寶可夢圖鑑',
    't_other_pokemon': '其他寶可夢',
    't_select_pokemon': '選擇寶可夢',
    't_set_pokemon_level': '設定寶可夢等級',
    't_delete_pokemon': '刪除寶可夢',
    't_hold_someone_pokemon': '擁有「@someone」寶可夢',
    't_pokemon_173': '卡比獸', // snorlax
    't_evolutionary_stage': '進化階段',
    't_current_stage': '目前階段',
    't_final_stage': '最終階段',
    // endregion
    // region ## Attributes
    't_abilities': '能力',
    't_sleep_type': '睡眠類型',
    't_specialty': '專長',
    't_help_interval': '間隔時間',
    't_help_interval_2': '幫忙間隔',
    't_help_interval_base': '間隔時間(基礎)',
    't_max_carry': '持有上限',
    't_help_ability': '幫忙能力',
    // endregion
    // endregion

    // region # Team
    't_form_team': '編組隊伍',
    't_helper_team': '幫手隊伍',
    't_auto_form_team': '自動組隊',
    // endregion

    // region # Skill
    't_skills': '技能',
    't_main_skill': '主技能',
    't_main_skills': '主技能',
    't_sub_skills': '副技能',
    // endregion

    // region # Food
    't_no_match_other_ingredient_of_dish_hint': '不满足其它食谱的任意食材',
    // region ## Pot
    't_dish_maker': '製作料理',
    't_capacity': '容量',
    't_pot': '鍋子',
    // endregion
    // region ## Dish
    't_set_recipe_level': '設定食譜等級',
    't_soup': '濃湯',
    't_curry': '咖哩',
    't_desserts': '點心',
    't_drinks': '飲料',
    't_salad': '沙拉',
    // endregion
    // endregion

    // region # Sleep
    't_sleep_face': '睡姿',
    't_sleep_faces': '睡姿',
    't_sleep_illustrated_book': '睡姿圖鑑',
    // endregion

    // region # Others
    't_character': '性格',
    't_ingredient': '食材',
    't_ingredients': '食材',
    't_fruit': '樹果',
    't_fruits': '樹果',
    't_food': '料理',
    't_recipes': '食譜',
    't_recipes_view': '食譜一覽',
    // endregion

    // region # Candy
    't_hold_candies': '擁有糖果',
    't_candy_unit': '顆',
    't_candies': '糖果',
    't_candies_info_text': '1. 萬能糖果S可以產生3個指定寶可夢的一般糖果\n2. 一般糖果可以 +25 經驗值，但會受部分性格影響',
    't_exp_and_candies': '經驗值 & 糖果',
    't_special_exp_format_hint': '經驗計算與一般寶可夢不同',
    't_calculate_result': '計算結果',
    't_need_exp_next_level_prefix': '距離下一個等級還需要',
    // endregion

    // region # Level
    't_level': '等級',
    't_set_level': '設定等級',
    // endregion

    // region # Analysis
    't_review': '評價',
    't_analysis': '分析',
    // endregion

    // region # Evolution
    't_evolution': '進化',
    't_evolution_items': '進化道具',
    // endregion

  };
}