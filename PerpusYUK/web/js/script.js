/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
function openModal(id) {
    document.getElementById(id).classList.add('active');
}

function closeModal(id) {
    document.getElementById(id).classList.remove('active');
}

function konfirmasiHapus(pesan) {
    return confirm(pesan || 'Yakin ingin menghapus data ini?');
}

function filterTabel(inputId, tabelId) {
    var input = document.getElementById(inputId).value.toLowerCase();
    var rows = document.querySelectorAll('#' + tabelId + ' tbody tr');
    rows.forEach(function(row) {
        var text = row.innerText.toLowerCase();
        row.style.display = text.includes(input) ? '' : 'none';
    });
}

function isiFormEdit(id, judul, pengarang, kategori, isbn, stok) {
    document.getElementById('edit_id').value = id;
    document.getElementById('edit_judul').value = judul;
    document.getElementById('edit_pengarang').value = pengarang;
    document.getElementById('edit_kategori').value = kategori;
    document.getElementById('edit_isbn').value = isbn;
    document.getElementById('edit_stok').value = stok;
    openModal('modalEditBuku');
}

function isiFormEditAnggota(id, username) {
    document.getElementById('edit_anggota_id').value = id;
    document.getElementById('edit_anggota_username').value = username;
    openModal('modalEditAnggota');
}

