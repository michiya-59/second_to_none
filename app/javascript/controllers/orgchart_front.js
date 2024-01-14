// グループテンプレートのリンク部分を定義し、線のスタイルを設定
OrgChart.templates.group.link = '<path stroke-linejoin="round" stroke="#aeaeae" stroke-width="1px" fill="none" d="M{xa},{ya} {xb},{yb} {xc},{yc} L{xd},{yd}" />';

// グループテンプレートのノードメニューボタンを無効化
OrgChart.templates.group.nodeMenuButton = '';

// グループテンプレートを複製して、'min'という新しいテンプレートを作成
OrgChart.templates.group.min = Object.assign({}, OrgChart.templates.group);

// 'min'テンプレートに固有の変更を適用
OrgChart.templates.group.min.imgs = "{val}";
OrgChart.templates.group.min.img_0 = "";
OrgChart.templates.group.min.description = '<text data-width="230" data-text-overflow="multiline" style="font-size: 14px;" fill="#aeaeae" x="125" y="100" text-anchor="middle">{val}</text>';

var chart; // グローバル変数としてchartを定義

// 画面サイズが変更されたときに組織図の設定を更新する関数
function resizeChart() {
  var width = window.innerWidth;
  var height = window.innerHeight;

  if (width <= 768) {
    chart.config.width = width;
    chart.config.height = height;
    chart.config.enableDrag = true; // ドラッグ無効化
    chart.config.enableZoom = true; // ズーム無効化
  } else {
    chart.config.width = width * 0.8;
    chart.config.height = height * 0.8;
    chart.config.enableDrag = true; // ドラッグ有効化
    chart.config.enableZoom = true; // ズーム有効化
  }

  chart.draw();
}

document.addEventListener("DOMContentLoaded", function() {
  chart = new OrgChart(document.getElementById("tree"), {
    // 組織図の設定
    mouseScrool: OrgChart.none,
    template: "olivia",
    nodeMenu: {
      details: { text: "詳細", onClick: showUserDetails }
    },
    searchFields : ["name"],
    scroll: {
      enable: true, // スクロールを有効にする
    },
    editForm: {
      buttons: {
          edit: null,
          share: null,
          remove: null
      }
  },
    dragDropMenu: {
      addInGroup: { text: "Add in group" },
      addAsChild: { text: "Add as child" }
    },
    nodeBinding: {
      description: "description",
      field_0: "name",
      field_1: "title",
      img_0: "img"
    },
    tags: {
      "group": { template: "group" },
      "devs-group": { subTreeConfig: { columns: 2 } },
      "sales-group": { subTreeConfig: { columns: 1 } },
      "hrs-group": { min: true, subTreeConfig: { columns: 2 } },
      // 追加されたタグ設定
      "left-child": { template: "ana", subTreeConfig: { orientation: "left" } },
      "right-child": { template: "ana", subTreeConfig: { orientation: "right" } }
    },
    toolbar: {
      zoom: true,
      fit: true,
      expandAll: true
    }
  });

  resizeChart(); // 初期サイズ設定
  window.addEventListener('resize', resizeChart); // リサイズイベントリスナー追加

  // 組織図にデータをロード
  chart.load(gon.users);
});

// ユーザ詳細情報を表示する関数
function showUserDetails(nodeId) {
  var nodeData = chart.get(nodeId);
  var userDetails = `ユーザID: ${nodeData.id}\nユーザ名: ${nodeData.name}\nタイトル: ${nodeData.title}\n親ユーザID: ${nodeData.pid}\n親ユーザ名: ${nodeData.parent_name}`;
  alert(userDetails);
}
