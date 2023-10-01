import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class SleepFaceRepository implements MyInjectable {

  Future<Map<int, Map<int, String>>> findAll() async {
    return _getData();
  }

  /// 1st MapEntry: [PokemonBasicProfile.id] to 2nd MapEntry
  /// 2nd MapEntry: index (TODO: change to sleep face id, 遊戲中有 ID 可以看)
  ///               to sleep face name
  Map<int, Map<int, String>> _getData() {
    return {
      1: {
        1: "光合作用睡",
        2: "撐地睡",
        3: "伸出藤蔓睡",
      },
      2: {
        1: "光合作用睡",
        2: "撐地睡",
        3: "伸出藤蔓睡",
      },
      3: {
        1: "光合作用睡",
        2: "撐地睡",
        3: "伸出藤蔓睡",
      },
      4: {
        1: "火焰劈啪睡",
        2: "搓肚子睡",
        3: "露肚子睡",
      },
      5: {
        1: "臂枕睡",
        2: "坐著睡",
        3: "懶散睡",
      },
      6: {
        1: "趴地睡",
        2: "盤手睡",
        3: "露肚子睡",
      },
      7: {
        1: "縮入殼中睡",
        2: "不縮殼中睡",
        3: "朝天睡",
      },
      8: {
        1: "縮入殼中睡",
        2: "不縮殼中睡",
        3: "撲著睡",
      },
      9: {
        1: "縮入殼中睡",
        2: "不縮殼中睡",
        3: "朝天睡",
      },
      10: {
        1: "貼地睡",
        2: "頭重重睡",
        3: "吐絲睡",
      },
      11: {
        1: "靜靜睡",
        2: "搖搖晃晃睡",
        3: "變硬睡",
      },
      12: {
        1: "坐著飄飄睡",
        2: "飄浮睡",
        3: "撒鱗粉睡",
      },
      13: {
        1: "搔搔臉睡",
        2: "歪頭睡",
        3: "門牙咬咬睡",
      },
      14: {
        1: "磨牙睡",
        2: "呆立睡",
        3: "門牙咬咬睡",
      },
      15: {
        1: "盤圈睡",
        2: "伸縮睡",
        3: "鬆開睡",
      },
      16: {
        1: "盤圈睡",
        2: "傾斜睡",
        3: "鬆開睡",
      },
      18: {
        1: "窩起來睡",
        2: "垂耳睡",
        3: "放電睡",
      },
      19: {
        1: "尾巴晃晃睡",
        2: "坐著睡",
        3: "尾巴接地睡",
      },
      107: {
        1: "安穩睡",
        2: "打盹睡",
        3: "揮指睡",
      },
      108: {
        1: "安穩睡",
        2: "打盹睡",
        3: "揮指睡",
      },
      21: {
        1: "坐著睡",
        2: "迷糊睡",
        3: "唱歌睡",
      },
      22: {
        1: "微笑睡",
        2: "嚇了又睡",
        3: "膨膨睡",
      },
      23: {
        1: "地下睡",
        2: "地上睡",
        3: "挖洞睡",
      },
      24: {
        1: "地下睡",
        2: "地上睡",
        3: "三胞胎親密睡",
      },
      25: {
        1: "窩起來睡",
        2: "坐著睡",
        3: "聚寶功睡",
      },
      26: {
        1: "優雅睡",
        2: "撐地睡",
        3: "道歉睡",
      },
      27: {
        1: "頭痛睡",
        2: "大哈欠睡",
        3: "不要不要睡",
      },
      28: {
        1: "臂枕睡",
        2: "抓屁屁睡",
        3: "游泳睡",
      },
      29: {
        1: "發怒睡",
        2: "呆立睡",
        3: "安穩睡",
      },
      30: {
        1: "發怒睡",
        2: "跺腳睡",
        3: "安穩睡",
      },
      31: {
        1: "伸展睡",
        2: "端坐睡",
        3: "肚子朝天睡",
      },
      32: {
        1: "趴著睡",
        2: "端坐睡",
        3: "肚子朝天睡",
      },
      33: {
        1: "伸腳睡",
        2: "溶解液睡",
        3: "扎根睡",
      },
      34: {
        1: "溶解液睡",
        2: "飄浮睡",
        3: "黏著睡",
      },
      35: {
        1: "哈呼哈呼睡",
        2: "藤蔓撐著睡",
        3: "朝天睡",
      },
      36: {
        1: "盤手睡",
        2: "忍耐睡",
        3: "陷下去睡",
      },
      37: {
        1: "躺～著睡",
        2: "豪爽睡",
        3: "滾來滾去睡",
      },
      38: {
        1: "沉甸甸睡",
        2: "霸氣站著睡",
        3: "滾來滾去睡",
      },
      39: {
        1: "懶懶睡",
        2: "呆呆睡",
        3: "憨憨睡",
      },
      40: {
        1: "親密睡",
        2: "流口水睡",
        3: "被咬尾巴睡",
      },
      42: {
        1: "斜著飄飄睡",
        2: "電磁飄飄睡",
        3: "顛倒飄飄睡",
      },
      43: {
        1: "黏著飄飄睡",
        2: "搖搖欲墜飄飄睡",
        3: "各飄各的睡",
      },
      45: {
        1: "放哨睡",
        2: "放哨偷懶睡",
        3: "雙胞胎睡",
      },
      46: {
        1: "放哨睡",
        2: "放哨偷懶睡",
        3: "三胞胎睡",
      },
      47: {
        1: "笑嘻嘻睡",
        2: "氣體飄飄睡",
        3: "做鬼臉睡",
      },
      48: {
        1: "歪頭睡",
        2: "氣體飄飄睡",
        3: "做鬼臉睡",
      },
      49: {
        1: "惡作劇睡",
        2: "咧嘴笑睡",
        3: "做鬼臉睡",
      },
      50: {
        1: "哭哭睡",
        2: "骨頭搔搔睡",
        3: "枕枕骨頭睡",
      },
      51: {
        1: "抱抱骨頭睡",
        2: "骨頭搔搔睡",
        3: "枕枕骨頭睡",
      },
      52: {
        1: "親子情深睡",
        2: "親子同步睡",
        3: "一個不睡一個睡",
      },
      106: {
        1: "默劇摸牆睡",
        2: "小石砸頭睡",
        3: "默劇床上睡",
      },
      53: {
        1: "大膽睡",
        2: "呆立睡",
        3: "遁地睡",
      },
      54: {
        1: "變成石頭睡",
        2: "原樣睡",
        3: "皮卡丘睡",
        5: "妙蛙種子睡",
        6: "小火龍睡",
        7: "傑尼龜睡",
        10: "快龍睡",
        11: "幼基拉斯睡",
        12: "冰伊布睡",
      },
      55: {
        1: "窩起來睡",
        2: "垂耳睡",
        3: "精力充沛睡",
      },
      57: {
        1: "搖尾鰭睡",
        2: "端坐睡",
        3: "貼地睡",
      },
      58: {
        1: "趴著睡",
        2: "端坐睡",
        3: "夢中奔跑睡",
      },
      59: {
        1: "搖尾巴睡",
        2: "收手手睡",
        3: "圍尾巴睡",
      },
      59: {
        1: "盤圈睡",
        2: "扭扭睡",
        3: "鬆開睡",
      },
      59: {
        1: "盤圈睡",
        2: "扭扭睡",
        3: "鬆開睡",
      },
      59: {
        1: "窩起來睡",
        2: "坐著睡",
        3: "露肚子睡",
      },
      64: {
        1: "轉葉子睡",
        2: "垂葉子睡",
        3: "肚子朝天睡",
      },
      65: {
        1: "伸展睡",
        2: "甩甩花苞睡",
        3: "散發香氣睡",
      },
      66: {
        1: "安穩睡",
        2: "甩脖子睡",
        3: "遍地開花睡",
      },
      67: {
        1: "貼地睡",
        2: "屈身睡",
        3: "噴出火焰睡",
      },
      68: {
        1: "臂枕睡",
        2: "撲著睡",
        3: "噴出火焰睡",
      },
      69: {
        1: "臂枕睡",
        2: "理毛睡",
        3: "噴出火焰睡",
      },
      70: {
        1: "單眼睡",
        2: "輕咬睡",
        3: "張大嘴巴睡",
      },
      71: {
        1: "單眼睡",
        2: "露牙睡",
        3: "張大嘴巴睡",
      },
      72: {
        1: "單眼睡",
        2: "威嚇睡",
        3: "張大嘴巴睡",
      },
      17: {
        1: "安穩睡",
        2: "坐著睡",
        3: "放電睡",
      },
      109: {
        1: "滾滾睡",
        2: "打盹睡",
        3: "朝天睡",
      },
      20: {
        1: "彈起睡",
        2: "迷糊睡",
        3: "唱歌睡",
      },
      73: {
        1: "滾滾睡",
        2: "朝天睡",
        3: "殼中睡",
      },
      74: {
        1: "坐著揮翅睡",
        2: "立著揮翅睡",
        3: "浮空拍翅睡",
      },
      76: {
        1: "蓬蓬睡",
        2: "蹄子扒扒睡",
        3: "尾巴閃閃睡",
      },
      77: {
        1: "貼地睡",
        2: "蓬蓬睡",
        3: "尾巴閃閃睡",
      },
      78: {
        1: "搔尾巴睡",
        2: "甩脖子睡",
        3: "尾巴光耀睡",
      },
      80: {
        1: "裝樹睡",
        2: "半裝樹睡",
        3: "不裝樹睡",
      },
      60: {
        1: "預知睡",
        2: "端坐睡",
        3: "肚子朝天睡",
      },
      61: {
        1: "新月睡",
        2: "端坐睡",
        3: "肚子朝天睡",
      },
      41: {
        1: "懶散睡",
        2: "賢者睡",
        3: "靈光一閃睡",
      },
      82: {
        1: "藏尾巴睡",
        2: "忍耐睡",
        3: "招牌姿勢睡",
      },
      83: {
        1: "晃晃角睡",
        2: "呆立睡",
        3: "舔蜜睡",
      },
      84: {
        1: "長嚎睡",
        2: "伸展睡",
        3: "肚子朝天睡",
      },
      85: {
        1: "趴著睡",
        2: "撐地睡",
        3: "噴火睡",
      },
      86: {
        1: "伸展睡",
        2: "搓搓臉睡",
        3: "吃土睡",
      },
      87: {
        1: "倒下睡",
        2: "抖抖睡",
        3: "排氣睡",
      },
      88: {
        1: "趴地睡",
        2: "霸氣站著睡",
        3: "大字睡",
      },
      89: {
        1: "懶惰睡",
        2: "理毛睡",
        3: "偷吃睡",
      },
      90: {
        1: "蠢蠢欲動睡",
        2: "做體操睡",
        3: "懶惰睡",
      },
      91: {
        1: "大字睡",
        2: "懶散睡",
        3: "偷吃睡",
      },
      92: {
        1: "大字睡",
        2: "震震睡",
        3: "吃寶石睡",
      },
      93: {
        1: "氣球睡",
        2: "點頭睡",
        3: "張大嘴巴睡",
      },
      94: {
        1: "後仰睡",
        2: "點頭睡",
        3: "張大嘴巴睡",
      },
      95: {
        1: "羽棲睡",
        2: "拍拍睡",
        3: "一朵綿雲睡",
      },
      96: {
        1: "包在羽中睡",
        2: "羽棲睡",
        3: "一朵綿雲睡",
      },
      97: {
        1: "收手手睡",
        2: "危險測知睡",
        3: "肚子朝天睡",
      },
      81: {
        1: "尾巴回原位睡",
        2: "忍耐睡",
        3: "招牌姿勢睡",
      },
      98: {
        1: "咕咚呼嚕睡",
        2: "大哈欠睡",
        3: "拍手睡",
      },
      99: {
        1: "腳咚咚睡",
        2: "大哈欠睡",
        3: "朝天睡",
      },
      100: {
        1: "懶散睡",
        2: "威嚴睡",
        3: "插獠牙睡",
      },
      79: {
        1: "咕咚呼嚕睡",
        2: "呆立睡",
        3: "眼睛出水睡",
      },
      105: {
        1: "手張開開睡",
        2: "呆立睡",
        3: "默劇床上睡",
      },
      101: {
        1: "抱膝睡",
        2: "邊修行邊睡",
        3: "立單膝睡",
      },
      102: {
        1: "立單膝睡",
        2: "邊修行邊睡",
        3: "不修行在睡",
      },
      103: {
        1: "懶散睡",
        2: "臉頰鼓鼓睡",
        3: "拉拉背睡",
      },
      104: {
        1: "懶散睡",
        2: "喉嚨鼓鼓睡",
        3: "毒囊枕睡",
      },
      44: {
        1: "搖搖飄飄睡",
        2: "監視飄飄睡",
        3: "顛倒飄飄睡",
      },
      75: {
        1: "自在飛行睡",
        2: "立著揮翅睡",
        3: "特技飛行睡",
      },
      62: {
        1: "搖尾巴睡",
        2: "撐地睡",
        3: "抓葉子睡",
      },
      63: {
        1: "臂枕睡",
        2: "撐地睡",
        3: "貼地睡",
      },
      56: {
        1: "窩起來睡",
        2: "撐地睡",
        3: "緞帶纏身睡",
      },
    };
  }

}