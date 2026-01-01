<!doctype html>
<html lang="vi" class="h-full">
 <head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thống Kê Thu Chi</title>
  <script src="/_sdk/data_sdk.js"></script>
  <script src="/_sdk/element_sdk.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    body {
      box-sizing: border-box;
    }
  </style>
  <style>@view-transition { navigation: auto; }</style>
 </head>
 <body class="h-full">
  <div id="app" class="w-full h-full overflow-auto bg-gradient-to-br from-blue-50 to-indigo-100">
   <div class="max-w-5xl mx-auto p-6"><!-- Header -->
    <div class="text-center mb-8">
     <h1 id="appTitle" class="text-4xl font-bold text-indigo-900 mb-2">Thống Kê Thu Chi</h1>
     <p class="text-indigo-600">Quản lý và tính toán lãi lỗ hàng ngày</p>
    </div><!-- Form nhập liệu -->
    <div class="bg-white rounded-2xl shadow-xl p-6 mb-6">
     <h2 class="text-2xl font-bold text-gray-800 mb-6">📝 Nhập Dữ Liệu Hôm Nay</h2>
     <form id="dataForm" class="space-y-6"><!-- Ngày -->
      <div><label for="date" class="block text-sm font-semibold text-gray-700 mb-2">📅 Ngày</label> <input type="date" id="date" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
      </div><!-- Tồn hôm qua -->
      <div class="bg-yellow-50 p-4 rounded-lg border-2 border-yellow-200">
       <h3 class="text-lg font-bold text-yellow-800 mb-4">📦 Tồn Hôm Qua</h3>
       <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div><label for="tonKg" class="block text-sm font-semibold text-gray-700 mb-2">Số kg</label> <input type="number" id="tonKg" step="0.01" value="0" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500">
        </div>
        <div><label for="tonGia" class="block text-sm font-semibold text-gray-700 mb-2">Đơn giá (VNĐ)</label> <input type="number" id="tonGia" step="0.01" value="0" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500">
        </div>
        <div><label class="block text-sm font-semibold text-gray-700 mb-2">Thành tiền</label>
         <div id="tonTien" class="w-full px-4 py-3 bg-yellow-100 rounded-lg font-bold text-yellow-800 border-2 border-yellow-300">
          0 ₫
         </div>
        </div>
       </div>
      </div><!-- Nhập mới -->
      <div class="bg-green-50 p-4 rounded-lg border-2 border-green-200">
       <h3 class="text-lg font-bold text-green-800 mb-4">📥 Nhập Mới</h3>
       <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div><label for="nhapKg" class="block text-sm font-semibold text-gray-700 mb-2">Số kg</label> <input type="number" id="nhapKg" step="0.01" value="0" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500">
        </div>
        <div><label for="nhapGia" class="block text-sm font-semibold text-gray-700 mb-2">Đơn giá (VNĐ)</label> <input type="number" id="nhapGia" step="0.01" value="0" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500">
        </div>
        <div><label class="block text-sm font-semibold text-gray-700 mb-2">Thành tiền</label>
         <div id="nhapTien" class="w-full px-4 py-3 bg-green-100 rounded-lg font-bold text-green-800 border-2 border-green-300">
          0 ₫
         </div>
        </div>
       </div>
      </div><!-- Bán ra -->
      <div class="bg-blue-50 p-4 rounded-lg border-2 border-blue-200">
       <h3 class="text-lg font-bold text-blue-800 mb-4">💰 Bán Ra</h3>
       <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div><label for="banKg" class="block text-sm font-semibold text-gray-700 mb-2">Số kg</label> <input type="number" id="banKg" step="0.01" value="0" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
        </div>
        <div><label for="banGia" class="block text-sm font-semibold text-gray-700 mb-2">Đơn giá (VNĐ)</label> <input type="number" id="banGia" step="0.01" value="0" required class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
        </div>
        <div><label class="block text-sm font-semibold text-gray-700 mb-2">Thành tiền</label>
         <div id="banTien" class="w-full px-4 py-3 bg-blue-100 rounded-lg font-bold text-blue-800 border-2 border-blue-300">
          0 ₫
         </div>
        </div>
       </div>
      </div><!-- Nút submit --> <button type="submit" id="submitBtn" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 px-6 rounded-lg transition transform hover:scale-105 shadow-lg"> <span id="submitBtnText">📊 Tính Toán</span> </button>
     </form>
    </div><!-- Kết quả tính toán -->
    <div id="resultSection" class="bg-white rounded-2xl shadow-xl p-6 mb-6 hidden">
     <h2 class="text-2xl font-bold text-gray-800 mb-6">📈 Kết Quả Chi Tiết</h2><!-- Thông tin vốn -->
     <div class="bg-gradient-to-r from-purple-50 to-indigo-50 p-6 rounded-lg border-2 border-purple-200 mb-6">
      <h3 class="text-xl font-bold text-purple-900 mb-4">💼 Thông Tin Vốn</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
       <div>
        <p class="text-sm text-gray-600 mb-1">Tổng số kg có sẵn</p>
        <p id="tongKgCoSan" class="text-2xl font-bold text-purple-900">0 kg</p>
       </div>
       <div>
        <p class="text-sm text-gray-600 mb-1">Giá vốn bình quân</p>
        <p id="giaVonBinhQuan" class="text-2xl font-bold text-purple-900">0 ₫/kg</p>
       </div>
      </div>
     </div><!-- Thống kê bán hàng -->
     <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
      <div class="bg-blue-50 p-6 rounded-lg border-2 border-blue-200">
       <h3 class="text-lg font-bold text-blue-800 mb-2">📊 Số Lượng Đã Bán</h3>
       <p id="resultBanKg" class="text-3xl font-bold text-blue-900">0 kg</p>
      </div>
      <div class="bg-cyan-50 p-6 rounded-lg border-2 border-cyan-200">
       <h3 class="text-lg font-bold text-cyan-800 mb-2">💰 Doanh Thu</h3>
       <p id="resultBanTien" class="text-3xl font-bold text-cyan-900">0 ₫</p>
      </div>
     </div><!-- Chi phí và tồn kho -->
     <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
      <div class="bg-rose-50 p-6 rounded-lg border-2 border-rose-200">
       <h3 class="text-lg font-bold text-rose-800 mb-2">💸 Giá Vốn Đã Bán</h3>
       <p id="giaVonDaBan" class="text-3xl font-bold text-rose-900">0 ₫</p>
       <p class="text-sm text-rose-700 mt-2">(Số kg bán × Giá vốn bình quân)</p>
      </div>
      <div class="bg-purple-50 p-6 rounded-lg border-2 border-purple-200">
       <h3 class="text-lg font-bold text-purple-800 mb-2">📦 Tồn Kho Còn Lại</h3>
       <p id="conLaiKg" class="text-3xl font-bold text-purple-900">0 kg</p>
       <p id="giaTriTonKho" class="text-sm text-purple-700 mt-2">Giá trị: 0 ₫</p>
      </div>
     </div><!-- Lãi lỗ -->
     <div class="grid grid-cols-1 gap-6">
      <div id="laiLoCard" class="p-6 rounded-lg border-2">
       <h3 class="text-lg font-bold mb-2">💵 Lãi/Lỗ</h3>
       <p id="laiLo" class="text-4xl font-bold mb-2">0 ₫</p>
       <p class="text-sm opacity-75">(Doanh thu - Giá vốn đã bán)</p>
      </div>
     </div>
    </div><!-- Lịch sử -->
    <div class="bg-white rounded-2xl shadow-xl p-6">
     <h2 class="text-2xl font-bold text-gray-800 mb-6">📋 Lịch Sử Giao Dịch</h2>
     <div id="recordsList" class="space-y-4">
      <p class="text-gray-500 text-center py-8">Chưa có giao dịch nào. Hãy nhập dữ liệu đầu tiên!</p>
     </div>
    </div>
   </div>
  </div>
  <script>
    const defaultConfig = {
      app_title: "Thống Kê Thu Chi",
      submit_button_text: "📊 Tính Toán",
      background_color: "#EEF2FF",
      card_color: "#FFFFFF",
      primary_color: "#4F46E5",
      text_color: "#1F2937",
      accent_color: "#818CF8",
      font_family: "system-ui, -apple-system, sans-serif",
      font_size: 16
    };

    let records = [];
    let recordCount = 0;

    // Format tiền
    function formatMoney(amount) {
      return new Intl.NumberFormat('vi-VN').format(Math.round(amount)) + ' ₫';
    }

    // Tính toán tự động
    function updateCalculations() {
      const tonKg = parseFloat(document.getElementById('tonKg').value) || 0;
      const tonGia = parseFloat(document.getElementById('tonGia').value) || 0;
      const nhapKg = parseFloat(document.getElementById('nhapKg').value) || 0;
      const nhapGia = parseFloat(document.getElementById('nhapGia').value) || 0;
      const banKg = parseFloat(document.getElementById('banKg').value) || 0;
      const banGia = parseFloat(document.getElementById('banGia').value) || 0;

      const tonTien = tonKg * tonGia;
      const nhapTien = nhapKg * nhapGia;
      const banTien = banKg * banGia;

      document.getElementById('tonTien').textContent = formatMoney(tonTien);
      document.getElementById('nhapTien').textContent = formatMoney(nhapTien);
      document.getElementById('banTien').textContent = formatMoney(banTien);
    }

    // Gắn sự kiện tính toán tự động
    ['tonKg', 'tonGia', 'nhapKg', 'nhapGia', 'banKg', 'banGia'].forEach(id => {
      document.getElementById(id).addEventListener('input', updateCalculations);
    });

    // Set ngày hiện tại
    document.getElementById('date').valueAsDate = new Date();

    // Xử lý form
    document.getElementById('dataForm').addEventListener('submit', async (e) => {
      e.preventDefault();
      
      if (recordCount >= 999) {
        showToast('Đã đạt giới hạn 999 giao dịch!', 'error');
        return;
      }

      const submitBtn = document.getElementById('submitBtn');
      const submitBtnText = document.getElementById('submitBtnText');
      const originalText = submitBtnText.textContent;
      
      submitBtn.disabled = true;
      submitBtnText.textContent = '⏳ Đang tính toán...';

      try {
        const tonKg = parseFloat(document.getElementById('tonKg').value) || 0;
        const tonGia = parseFloat(document.getElementById('tonGia').value) || 0;
        const nhapKg = parseFloat(document.getElementById('nhapKg').value) || 0;
        const nhapGia = parseFloat(document.getElementById('nhapGia').value) || 0;
        const banKg = parseFloat(document.getElementById('banKg').value) || 0;
        const banGia = parseFloat(document.getElementById('banGia').value) || 0;

        const tonTien = tonKg * tonGia;
        const nhapTien = nhapKg * nhapGia;
        const banTien = banKg * banGia;
        const conLaiKg = tonKg + nhapKg - banKg;
        
        // Tính giá vốn bình quân
        const tongKg = tonKg + nhapKg;
        const tongVon = tonTien + nhapTien;
        const giaVonBinhQuan = tongKg > 0 ? tongVon / tongKg : 0;
        
        // Tính lãi/lỗ dựa trên giá vốn của số kg đã bán
        const giaVonDaBan = banKg * giaVonBinhQuan;
        const laiLo = banTien - giaVonDaBan;

        const record = {
          id: Date.now().toString(),
          date: document.getElementById('date').value,
          ton_kg: tonKg,
          ton_gia: tonGia,
          ton_tien: tonTien,
          nhap_kg: nhapKg,
          nhap_gia: nhapGia,
          nhap_tien: nhapTien,
          ban_kg: banKg,
          ban_gia: banGia,
          ban_tien: banTien,
          con_lai_kg: conLaiKg,
          gia_von_binh_quan: giaVonBinhQuan,
          gia_von_da_ban: giaVonDaBan,
          lai_lo: laiLo,
          created_at: new Date().toISOString()
        };

        const result = await window.dataSdk.create(record);
        
        if (result.isOk) {
          showResult({ 
            tongKg, 
            giaVonBinhQuan, 
            conLaiKg, 
            laiLo, 
            banKg, 
            banTien, 
            giaVonDaBan 
          });
          
          // Reset form
          document.getElementById('tonKg').value = '0';
          document.getElementById('tonGia').value = '0';
          document.getElementById('nhapKg').value = '0';
          document.getElementById('nhapGia').value = '0';
          document.getElementById('banKg').value = '0';
          document.getElementById('banGia').value = '0';
          document.getElementById('date').valueAsDate = new Date();
          updateCalculations();
          
          showToast('Tính toán thành công!', 'success');
        } else {
          showToast('Lỗi khi lưu dữ liệu. Vui lòng thử lại!', 'error');
        }
      } catch (error) {
        showToast('Có lỗi xảy ra. Vui lòng kiểm tra lại!', 'error');
      } finally {
        submitBtn.disabled = false;
        submitBtnText.textContent = originalText;
      }
    });

    function showToast(message, type = 'info') {
      const toast = document.createElement('div');
      const bgColor = type === 'success' ? 'bg-green-500' : type === 'error' ? 'bg-red-500' : 'bg-blue-500';
      toast.className = `fixed top-4 right-4 ${bgColor} text-white px-6 py-4 rounded-lg shadow-xl z-50 font-bold animate-bounce`;
      toast.textContent = message;
      document.body.appendChild(toast);
      setTimeout(() => {
        toast.style.animation = 'none';
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.5s';
        setTimeout(() => toast.remove(), 500);
      }, 3000);
    }

    function showResult(data) {
      const resultSection = document.getElementById('resultSection');
      resultSection.classList.remove('hidden');
      
      const { tongKg, giaVonBinhQuan, conLaiKg, laiLo, banKg, banTien, giaVonDaBan } = data;
      const giaTriTonKho = conLaiKg * giaVonBinhQuan;

      document.getElementById('tongKgCoSan').textContent = tongKg.toFixed(2) + ' kg';
      document.getElementById('giaVonBinhQuan').textContent = formatMoney(giaVonBinhQuan) + '/kg';
      document.getElementById('resultBanKg').textContent = banKg.toFixed(2) + ' kg';
      document.getElementById('resultBanTien').textContent = formatMoney(banTien);
      document.getElementById('giaVonDaBan').textContent = formatMoney(giaVonDaBan);
      document.getElementById('conLaiKg').textContent = conLaiKg.toFixed(2) + ' kg';
      document.getElementById('giaTriTonKho').textContent = 'Giá trị: ' + formatMoney(giaTriTonKho);
      document.getElementById('laiLo').textContent = formatMoney(Math.abs(laiLo));
      
      const laiLoCard = document.getElementById('laiLoCard');
      if (laiLo < 0) {
        laiLoCard.className = 'p-6 rounded-lg border-2 bg-red-50 border-red-200';
        laiLoCard.querySelector('h3').className = 'text-lg font-bold mb-2 text-red-800';
        laiLoCard.querySelector('h3').textContent = '❌ LỖ';
        document.getElementById('laiLo').className = 'text-4xl font-bold mb-2 text-red-900';
      } else {
        laiLoCard.className = 'p-6 rounded-lg border-2 bg-green-50 border-green-200';
        laiLoCard.querySelector('h3').className = 'text-lg font-bold mb-2 text-green-800';
        laiLoCard.querySelector('h3').textContent = '✅ LÃI';
        document.getElementById('laiLo').className = 'text-4xl font-bold mb-2 text-green-900';
      }

      setTimeout(() => {
        resultSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }, 100);
    }

    function renderRecords() {
      const container = document.getElementById('recordsList');
      
      if (records.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-center py-8">Chưa có giao dịch nào. Hãy nhập dữ liệu đầu tiên!</p>';
        return;
      }

      const sortedRecords = [...records].sort((a, b) => new Date(b.date) - new Date(a.date));
      
      container.innerHTML = sortedRecords.map(record => {
        const giaTriTonKho = record.con_lai_kg * record.gia_von_binh_quan;
        return `
        <div class="border-2 border-gray-200 rounded-lg p-5 hover:shadow-lg transition bg-gradient-to-br from-white to-gray-50">
          <div class="flex justify-between items-center mb-4 pb-3 border-b-2 border-gray-200">
            <h3 class="font-bold text-xl text-gray-800">📅 ${new Date(record.date).toLocaleDateString('vi-VN')}</h3>
            <button onclick="deleteRecord('${record.__backendId}')" 
              class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg font-semibold transition text-sm">
              🗑️ Xóa
            </button>
          </div>
          
          <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
            <div class="bg-yellow-50 p-3 rounded-lg border border-yellow-200 text-center">
              <p class="text-xs text-yellow-700 mb-1">📦 Tồn</p>
              <p class="font-bold text-yellow-900">${record.ton_kg.toFixed(1)} kg</p>
              <p class="text-xs text-yellow-700">${formatMoney(record.ton_tien)}</p>
            </div>
            <div class="bg-green-50 p-3 rounded-lg border border-green-200 text-center">
              <p class="text-xs text-green-700 mb-1">📥 Nhập</p>
              <p class="font-bold text-green-900">${record.nhap_kg.toFixed(1)} kg</p>
              <p class="text-xs text-green-700">${formatMoney(record.nhap_tien)}</p>
            </div>
            <div class="bg-blue-50 p-3 rounded-lg border border-blue-200 text-center">
              <p class="text-xs text-blue-700 mb-1">💰 Bán</p>
              <p class="font-bold text-blue-900">${record.ban_kg.toFixed(1)} kg</p>
              <p class="text-xs text-blue-700">${formatMoney(record.ban_tien)}</p>
            </div>
            <div class="bg-purple-50 p-3 rounded-lg border border-purple-200 text-center">
              <p class="text-xs text-purple-700 mb-1">📊 Còn lại</p>
              <p class="font-bold text-purple-900">${record.con_lai_kg.toFixed(1)} kg</p>
              <p class="text-xs text-purple-700">${formatMoney(giaTriTonKho)}</p>
            </div>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
            <div class="bg-indigo-50 p-3 rounded-lg border border-indigo-200">
              <p class="text-xs text-indigo-700 mb-1">💼 Giá vốn BQ</p>
              <p class="font-bold text-indigo-900 text-lg">${formatMoney(record.gia_von_binh_quan)}/kg</p>
            </div>
            <div class="bg-rose-50 p-3 rounded-lg border border-rose-200">
              <p class="text-xs text-rose-700 mb-1">💸 Vốn đã bán</p>
              <p class="font-bold text-rose-900 text-lg">${formatMoney(record.gia_von_da_ban)}</p>
            </div>
            <div class="${record.lai_lo < 0 ? 'bg-red-50 border-red-200' : 'bg-green-50 border-green-200'} p-3 rounded-lg border">
              <p class="text-xs ${record.lai_lo < 0 ? 'text-red-700' : 'text-green-700'} mb-1">${record.lai_lo < 0 ? '❌ Lỗ' : '✅ Lãi'}</p>
              <p class="font-bold ${record.lai_lo < 0 ? 'text-red-900' : 'text-green-900'} text-lg">${formatMoney(Math.abs(record.lai_lo))}</p>
            </div>
          </div>
        </div>
      `}).join('');
    }

    async function deleteRecord(backendId) {
      const record = records.find(r => r.__backendId === backendId);
      if (!record) return;

      const deleteBtn = event.target;
      const originalText = deleteBtn.innerHTML;
      deleteBtn.disabled = true;
      deleteBtn.textContent = '⏳ Đang xóa...';

      const result = await window.dataSdk.delete(record);
      
      if (!result.isOk) {
        deleteBtn.disabled = false;
        deleteBtn.innerHTML = originalText;
        showToast('Lỗi khi xóa. Vui lòng thử lại!', 'error');
      } else {
        showToast('Đã xóa thành công!', 'success');
      }
    }

    window.deleteRecord = deleteRecord;

    const dataHandler = {
      onDataChanged(data) {
        records = data;
        recordCount = data.length;
        renderRecords();
      }
    };

    async function onConfigChange(config) {
      const appTitle = document.getElementById('appTitle');
      const submitBtnText = document.getElementById('submitBtnText');
      const app = document.getElementById('app');
      
      const customFont = config.font_family || defaultConfig.font_family;
      const baseFontStack = 'system-ui, -apple-system, BlinkMacSystemFont, sans-serif';
      const baseSize = config.font_size || defaultConfig.font_size;
      
      appTitle.textContent = config.app_title || defaultConfig.app_title;
      if (submitBtnText) {
        submitBtnText.textContent = config.submit_button_text || defaultConfig.submit_button_text;
      }
      
      appTitle.style.fontFamily = `${customFont}, ${baseFontStack}`;
      appTitle.style.fontSize = `${baseSize * 2}px`;
      
      document.body.style.fontSize = `${baseSize}px`;
      document.body.style.fontFamily = `${customFont}, ${baseFontStack}`;
      
      app.style.background = `linear-gradient(to bottom right, ${config.background_color || defaultConfig.background_color}, ${config.accent_color || defaultConfig.accent_color})`;
      
      document.querySelectorAll('.bg-white').forEach(el => {
        el.style.backgroundColor = config.card_color || defaultConfig.card_color;
      });
      
      document.querySelectorAll('button[type="submit"]').forEach(el => {
        el.style.backgroundColor = config.primary_color || defaultConfig.primary_color;
      });
      
      document.querySelectorAll('h1, h2, h3, p, label').forEach(el => {
        el.style.color = config.text_color || defaultConfig.text_color;
      });
    }

    async function init() {
      const dataResult = await window.dataSdk.init(dataHandler);
      if (!dataResult.isOk) {
        console.error('Failed to initialize data SDK');
      }

      if (window.elementSdk) {
        window.elementSdk.init({
          defaultConfig,
          onConfigChange,
          mapToCapabilities: (config) => ({
            recolorables: [
              {
                get: () => config.background_color || defaultConfig.background_color,
                set: (value) => {
                  config.background_color = value;
                  window.elementSdk.setConfig({ background_color: value });
                }
              },
              {
                get: () => config.card_color || defaultConfig.card_color,
                set: (value) => {
                  config.card_color = value;
                  window.elementSdk.setConfig({ card_color: value });
                }
              },
              {
                get: () => config.text_color || defaultConfig.text_color,
                set: (value) => {
                  config.text_color = value;
                  window.elementSdk.setConfig({ text_color: value });
                }
              },
              {
                get: () => config.primary_color || defaultConfig.primary_color,
                set: (value) => {
                  config.primary_color = value;
                  window.elementSdk.setConfig({ primary_color: value });
                }
              },
              {
                get: () => config.accent_color || defaultConfig.accent_color,
                set: (value) => {
                  config.accent_color = value;
                  window.elementSdk.setConfig({ accent_color: value });
                }
              }
            ],
            borderables: [],
            fontEditable: {
              get: () => config.font_family || defaultConfig.font_family,
              set: (value) => {
                config.font_family = value;
                window.elementSdk.setConfig({ font_family: value });
              }
            },
            fontSizeable: {
              get: () => config.font_size || defaultConfig.font_size,
              set: (value) => {
                config.font_size = value;
                window.elementSdk.setConfig({ font_size: value });
              }
            }
          }),
          mapToEditPanelValues: (config) => new Map([
            ["app_title", config.app_title || defaultConfig.app_title],
            ["submit_button_text", config.submit_button_text || defaultConfig.submit_button_text]
          ])
        });
      }
    }

    init();
  </script>
 <script>(function(){function c(){var b=a.contentDocument||a.contentWindow.document;if(b){var d=b.createElement('script');d.innerHTML="window.__CF$cv$params={r:'9b7210869015c7ba',t:'MTc2NzI3MTAxMC4wMDAwMDA='};var a=document.createElement('script');a.nonce='';a.src='/cdn-cgi/challenge-platform/scripts/jsd/main.js';document.getElementsByTagName('head')[0].appendChild(a);";b.getElementsByTagName('head')[0].appendChild(d)}}if(document.body){var a=document.createElement('iframe');a.height=1;a.width=1;a.style.position='absolute';a.style.top=0;a.style.left=0;a.style.border='none';a.style.visibility='hidden';document.body.appendChild(a);if('loading'!==document.readyState)c();else if(window.addEventListener)document.addEventListener('DOMContentLoaded',c);else{var e=document.onreadystatechange||function(){};document.onreadystatechange=function(b){e(b);'loading'!==document.readyState&&(document.onreadystatechange=e,c())}}}})();</script></body>
</html>
