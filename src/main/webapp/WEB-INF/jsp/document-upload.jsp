<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="docs.new"/> - <fmt:message key="app.title"/></title>
    <%@ include file="fragments/common-styles.jsp" %>
    <%@ page import="org.springframework.security.web.csrf.CsrfToken" %>
    <% 
        CsrfToken token = (CsrfToken) request.getAttribute("_csrf");
        if (token != null) {
    %>
    <meta name="_csrf" content="<%= token.getToken() %>"/>
    <meta name="_csrf_header" content="<%= token.getHeaderName() %>"/>
    <% } %>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet/documents" class="back-link">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            <fmt:message key="back"/>
        </a>

        <div class="page-header">
            <h2><fmt:message key="docs.new"/></h2>
            <p><fmt:message key="docs.new.hint"/></p>
        </div>

        <div class="card">
            <div class="form-group">
                <label><fmt:message key="doc.form.title"/> *</label>
                <input type="text" id="docTitle" placeholder="<fmt:message key="doc.form.title_placeholder"/>" />
            </div>

            <div class="form-group">
                <label><fmt:message key="doc.form.description"/></label>
                <textarea id="docDescription" rows="4" placeholder="<fmt:message key="doc.form.description_placeholder"/>"></textarea>
                <div id="ocrHint" class="hint" style="display:none; margin-top:8px; color:#00d4aa; font-size:12px;">
                    <fmt:message key="doc.ocr.filled_hint"/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label><fmt:message key="doc.form.date"/></label>
                    <input type="date" id="docDate" value="${today}" />
                </div>
                <div class="form-group">
                    <label><fmt:message key="doc.form.doctor"/></label>
                    <input type="text" id="docDoctor" placeholder="<fmt:message key="doc.form.doctor_placeholder"/>" />
                </div>
            </div>

            <div class="form-group">
                <label><fmt:message key="doc.form.files"/> *</label>
                <div class="file-upload" id="fileDropZone">
                    <input type="file" id="fileInput" multiple accept=".pdf,.jpg,.jpeg,.png" onchange="handleFileSelect(this)" />
                    <div class="file-upload-content">
                        <div class="file-icon">
                            <svg viewBox="0 0 24 24"><path d="M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM14 13v4h-4v-4H7l5-5 5 5h-3z"/></svg>
                        </div>
                        <div class="file-info">
                            <span class="file-text" id="fileText"><fmt:message key="doc.form.drop_files"/></span>
                            <span class="file-hint"><fmt:message key="doc.form.file_hint"/></span>
                        </div>
                    </div>
                </div>
                <div id="selectedFiles"></div>
            </div>

            <div class="form-group" id="ocrSection" style="display:none;">
                <label><fmt:message key="doc.ocr.title"/></label>
                <div id="ocrResults" class="ocr-results"></div>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/cabinet/documents" class="btn btn-outline"><fmt:message key="cancel"/></a>
                <button type="button" id="ocrBtn" class="btn btn-secondary" onclick="recognizeFiles()" disabled>
                    <svg viewBox="0 0 24 24" width="18" height="18"><path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z" fill="currentColor"/></svg>
                    <fmt:message key="doc.ocr.button"/>
                </button>
                <button type="button" id="uploadBtn" class="btn btn-primary" onclick="uploadAndSave()" disabled>
                    <svg viewBox="0 0 24 24" width="18" height="18"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                    <fmt:message key="doc.form.create"/>
                </button>
            </div>
        </div>

        <div id="loadingOverlay" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(10,14,23,0.9); z-index:1000; align-items:center; justify-content:center; flex-direction:column;">
            <div style="width:50px; height:50px; border:3px solid rgba(0,212,170,0.3); border-top-color:#00d4aa; border-radius:50%; animation:spin 1s linear infinite;"></div>
            <p style="color:#fff; margin-top:20px;" id="loadingText"><fmt:message key="doc.uploading"/></p>
        </div>
    </main>

    <style>
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; color: #e5e5e5; font-size: 14px; font-weight: 500; margin-bottom: 8px; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px 16px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; color: #fff; font-size: 14px; }
        .form-group input:focus, .form-group textarea:focus { outline: none; border-color: #00d4aa; }
        .form-group textarea { resize: vertical; min-height: 100px; }
        .form-actions { display: flex; gap: 16px; margin-top: 24px; flex-wrap: wrap; }
        .file-upload { position: relative; }
        .file-upload input[type="file"] { position: absolute; top:0; left:0; width:100%; height:100%; opacity:0; cursor:pointer; z-index:1; }
        .file-upload-content { background:rgba(255,255,255,0.03); border:2px dashed rgba(255,255,255,0.1); border-radius:16px; padding:32px; text-align:center; transition:all 0.3s; }
        .file-upload:hover .file-upload-content { border-color:#00d4aa; background:rgba(0,212,170,0.05); }
        .file-icon { width:56px; height:56px; background:linear-gradient(135deg,rgba(0,212,170,0.2),rgba(0,163,255,0.2)); border-radius:14px; display:flex; align-items:center; justify-content:center; margin:0 auto 16px; }
        .file-icon svg { width:28px; height:28px; fill:#00d4aa; }
        .file-text { color:#fff; font-size:15px; font-weight:500; display:block; margin-bottom:6px; }
        .file-hint { color:#6b7280; font-size:13px; }
        .selected-files { margin-top:16px; display:flex; flex-direction:column; gap:8px; }
        .selected-file { display:flex; align-items:center; gap:12px; padding:12px 16px; background:rgba(0,212,170,0.05); border:1px solid rgba(0,212,170,0.2); border-radius:10px; }
        .selected-file-icon { width:36px; height:36px; background:linear-gradient(135deg,#00d4aa,#00a3ff); border-radius:8px; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .selected-file-icon svg { width:18px; height:18px; fill:#0a0e17; }
        .selected-file-name { flex:1; color:#fff; font-size:14px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .selected-file-size { color:#6b7280; font-size:12px; }
        .selected-file-status { font-size:12px; color:#00d4aa; }
        .selected-file-status.processing { color:#fbbf24; }
        .selected-file-status.error { color:#f87171; }
        .ocr-results { background:rgba(255,255,255,0.03); border:1px solid rgba(0,212,170,0.2); border-radius:12px; padding:16px; max-height:300px; overflow-y:auto; }
        .ocr-file-result { margin-bottom:16px; padding-bottom:16px; border-bottom:1px solid rgba(255,255,255,0.1); }
        .ocr-file-result:last-child { margin-bottom:0; padding-bottom:0; border-bottom:none; }
        .ocr-file-header { display:flex; align-items:center; gap:8px; margin-bottom:8px; color:#00d4aa; font-size:13px; font-weight:500; }
        .ocr-file-header svg { width:16px; height:16px; }
        .ocr-text { background:rgba(0,0,0,0.2); border-radius:8px; padding:12px; color:#e5e5e5; font-size:13px; line-height:1.6; white-space:pre-wrap; max-height:150px; overflow-y:auto; }
        .ocr-text.empty { color:#6b7280; font-style:italic; }
        @keyframes spin { to { transform: rotate(360deg); } }
        @media(max-width:600px) { .form-row { grid-template-columns:1fr; } .form-actions { flex-direction:column; } .form-actions .btn { width:100%; } }
    </style>

    <script>
        let selectedFiles = [];
        let ocrSessionId = null;
        let ocrResults = {};

        function getCsrfToken() {
            return document.querySelector('meta[name="_csrf"]')?.content || '';
        }

        function getCsrfHeader() {
            return document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
        }

        async function fetchWithCsrf(url, options = {}) {
            const token = getCsrfToken();
            const header = getCsrfHeader();
            if (token) {
                options.headers = options.headers || {};
                options.headers[header] = token;
            }
            return fetch(url, options);
        }

        function handleFileSelect(input) {
            const container = document.getElementById('selectedFiles');
            const fileText = document.getElementById('fileText');
            const ocrBtn = document.getElementById('ocrBtn');
            const uploadBtn = document.getElementById('uploadBtn');
            const ocrSection = document.getElementById('ocrSection');
            
            selectedFiles = Array.from(input.files);
            
            if (selectedFiles.length > 0) {
                fileText.textContent = selectedFiles.length + ' <fmt:message key="doc.files_selected"/>';
                ocrBtn.disabled = false;
                uploadBtn.disabled = false;
                
                ocrSection.style.display = 'none';
                ocrResults = {};
                ocrSessionId = null;
                
                container.innerHTML = '';
                selectedFiles.forEach((file, i) => {
                    const div = document.createElement('div');
                    div.className = 'selected-file';
                    div.innerHTML = '<div class="selected-file-icon"><svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg></div><span class="selected-file-name">' + file.name + '</span><span class="selected-file-size">' + formatSize(file.size) + '</span>';
                    container.appendChild(div);
                });
                
                const dateInput = document.getElementById('docDate');
                if (!dateInput.value) {
                    const firstFile = selectedFiles[0];
                    const date = extractDateFromFilename(firstFile.name);
                    if (date) dateInput.value = date;
                }
            } else {
                fileText.textContent = '<fmt:message key="doc.form.drop_files"/>';
                ocrBtn.disabled = true;
                uploadBtn.disabled = true;
                container.innerHTML = '';
                ocrSection.style.display = 'none';
            }
        }

        async function recognizeFiles() {
            if (selectedFiles.length === 0) return;
            
            const loading = document.getElementById('loadingOverlay');
            const loadingText = document.getElementById('loadingText');
            const ocrBtn = document.getElementById('ocrBtn');
            
            loading.style.display = 'flex';
            loadingText.textContent = '<fmt:message key="doc.ocr.processing"/>';
            ocrBtn.disabled = true;
            
            const container = document.getElementById('selectedFiles');
            container.querySelectorAll('.selected-file').forEach(el => {
                el.querySelector('.selected-file-status')?.remove();
                const status = document.createElement('span');
                status.className = 'selected-file-status processing';
                status.textContent = '<fmt:message key="doc.ocr.status.processing"/>';
                el.appendChild(status);
            });
            
            try {
                const formData = new FormData();
                selectedFiles.forEach((file, i) => {
                    formData.append('file_' + i, file);
                });
                
                const response = await fetchWithCsrf('${pageContext.request.contextPath}/api/ocr/upload-and-recognize', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                
                if (result.success) {
                    ocrSessionId = result.sessionId;
                    ocrResults = {};
                    
                    let combinedText = '';
                    result.files.forEach((fileInfo, i) => {
                        ocrResults[fileInfo.originalName] = fileInfo.recognizedText || '';
                        if (fileInfo.recognizedText) {
                            combinedText += (combinedText ? '\n\n' : '') + fileInfo.recognizedText;
                        }
                    });
                    
                    const ocrSection = document.getElementById('ocrSection');
                    const ocrResultsDiv = document.getElementById('ocrResults');
                    
                    let html = '';
                    result.files.forEach((fileInfo, i) => {
                        const text = fileInfo.recognizedText || '';
                        const hasText = text.length > 0;
                        html += '<div class="ocr-file-result">' +
                            '<div class="ocr-file-header">' +
                                '<svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6z"/></svg>' +
                                fileInfo.originalName + ' (' + fileInfo.textLength + ' <fmt:message key="doc.ocr.chars"/>)' +
                            '</div>' +
                            '<div class="ocr-text ' + (hasText ? '' : 'empty') + '">' +
                                (hasText ? text : '<fmt:message key="doc.ocr.no_text"/>') +
                            '</div></div>';
                    });
                    
                    ocrResultsDiv.innerHTML = html;
                    ocrSection.style.display = 'block';
                    
                    if (combinedText && !document.getElementById('docDescription').value.trim()) {
                        document.getElementById('docDescription').value = combinedText;
                        document.getElementById('ocrHint').style.display = 'block';
                    }
                    
                    container.querySelectorAll('.selected-file').forEach(el => {
                        el.querySelector('.selected-file-status')?.remove();
                        const status = document.createElement('span');
                        status.className = 'selected-file-status';
                        status.textContent = '<fmt:message key="doc.ocr.status.done"/>';
                        el.appendChild(status);
                    });
                    
                } else {
                    alert('OCR failed: ' + (result.error || 'Unknown error'));
                    container.querySelectorAll('.selected-file').forEach(el => {
                        el.querySelector('.selected-file-status')?.remove();
                        const status = document.createElement('span');
                        status.className = 'selected-file-status error';
                        status.textContent = '<fmt:message key="doc.ocr.status.error"/>';
                        el.appendChild(status);
                    });
                }
            } catch (e) {
                alert('Error: ' + e.message);
                container.querySelectorAll('.selected-file').forEach(el => {
                    const status = el.querySelector('.selected-file-status');
                    if (status) status.textContent = '<fmt:message key="doc.ocr.status.error"/>';
                });
            } finally {
                loading.style.display = 'none';
                ocrBtn.disabled = false;
            }
        }

        async function uploadAndSave() {
            const title = document.getElementById('docTitle').value.trim();
            if (!title) { alert('<fmt:message key="doc.error.title_required"/>'); return; }
            if (selectedFiles.length === 0) { alert('<fmt:message key="doc.error.files_required"/>'); return; }
            
            const loading = document.getElementById('loadingOverlay');
            const loadingText = document.getElementById('loadingText');
            loading.style.display = 'flex';
            loadingText.textContent = '<fmt:message key="doc.uploading"/>';
            
            try {
                const formData = new FormData();
                formData.append('title', title);
                formData.append('description', document.getElementById('docDescription').value);
                formData.append('documentDate', document.getElementById('docDate').value);
                formData.append('doctorName', document.getElementById('docDoctor').value);
                if (ocrSessionId) {
                    formData.append('sessionId', ocrSessionId);
                }
                selectedFiles.forEach(file => formData.append('files', file));
                
                const response = await fetchWithCsrf('${pageContext.request.contextPath}/cabinet/documents', {
                    method: 'POST',
                    body: formData
                });
                
                if (response.ok || response.redirected) {
                    if (ocrSessionId) {
                        try {
                            await fetchWithCsrf('${pageContext.request.contextPath}/api/ocr/cancel', {
                                method: 'POST',
                                headers: {'Content-Type': 'application/json'},
                                body: JSON.stringify({sessionId: ocrSessionId})
                            });
                        } catch(e) {}
                    }
                    window.location.href = '${pageContext.request.contextPath}/cabinet/documents?created=true';
                } else {
                    alert('Upload failed');
                }
            } catch (e) {
                alert('Error: ' + e.message);
            } finally {
                loading.style.display = 'none';
            }
        }

        function extractDateFromFilename(filename) {
            const match = filename.match(/(\d{2})[_\.-](\d{2})[_\.-](\d{2,4})/);
            if (match) {
                let y = match[3].length === 2 ? '20' + match[3] : match[3];
                let m = match[2];
                let d = match[1];
                return y + '-' + m + '-' + d;
            }
            return null;
        }

        function formatSize(bytes) {
            if (bytes < 1024) return bytes + ' B';
            if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
            return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
        }
    </script>
</body>
</html>
