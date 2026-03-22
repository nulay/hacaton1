<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="doc.edit.title"/> - <fmt:message key="app.title"/></title>
    <%@ include file="fragments/common-styles.jsp" %>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet/documents/${document.id}/view?lang=${pageContext.response.locale.language}" class="back-link">
            <svg viewBox="0 0 24 24" width="20" height="20"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            <fmt:message key="back"/>
        </a>

        <div class="page-header">
            <h2><fmt:message key="doc.edit.title"/></h2>
            <p>${document.title}</p>
        </div>

        <div class="card">
            <form method="post" action="${pageContext.request.contextPath}/cabinet/documents/${document.id}/edit?lang=${pageContext.response.locale.language}" enctype="multipart/form-data" id="editForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                
                <div class="form-group">
                    <label><fmt:message key="doc.form.title"/> *</label>
                    <input type="text" name="title" value="${document.title}" placeholder="<fmt:message key="doc.form.title_placeholder"/>" required />
                </div>

                <div class="form-group">
                    <label><fmt:message key="doc.form.description"/></label>
                    <textarea name="description" rows="3" placeholder="<fmt:message key="doc.form.description_placeholder"/>">${document.description}</textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label><fmt:message key="doc.form.date"/> *</label>
                        <input type="date" name="documentDate" value="${document.documentDateFormatted}" required />
                    </div>
                    <div class="form-group">
                        <label><fmt:message key="doc.form.doctor"/></label>
                        <input type="text" name="doctorName" value="${document.doctorName}" placeholder="<fmt:message key="doc.form.doctor_placeholder"/>" />
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/cabinet/documents/${document.id}/view?lang=${pageContext.response.locale.language}" class="btn btn-outline"><fmt:message key="cancel"/></a>
                    <button type="submit" class="btn btn-primary">
                        <svg viewBox="0 0 24 24"><path d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/></svg>
                        <fmt:message key="doc.form.update"/>
                    </button>
                </div>
            </form>

            <div class="files-section">
                <h3><fmt:message key="doc.edit.current_files"/> (${document.fileCount})</h3>
                <div class="files-list">
                    <c:forEach var="file" items="${document.files}" varStatus="status">
                        <div class="file-item">
                            <div class="file-item-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                            </div>
                            <div class="file-item-info">
                                <span class="file-item-name">${file.fileName}</span>
                                <span class="file-item-size">${file.fileSize}</span>
                            </div>
                            <button type="button" class="btn btn-small btn-outline btn-view" onclick="openViewer(${status.index})">
                                <svg viewBox="0 0 24 24" width="14" height="14"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z"/></svg>
                                <fmt:message key="open"/>
                            </button>
                            <a href="${pageContext.request.contextPath}/cabinet/documents/${document.id}/download/${file.id}" class="btn btn-small btn-outline">
                                <svg viewBox="0 0 24 24" width="14" height="14"><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>
                                <fmt:message key="download"/>
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/cabinet/documents/${document.id}/deletefile/${file.id}?lang=${pageContext.response.locale.language}" style="display: inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn-icon btn-delete" title="<fmt:message key="delete"/>" onclick="return confirm('<fmt:message key="doc.edit.file_deleted"/>')">
                                    <svg viewBox="0 0 24 24" width="16" height="16"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                    <c:if test="${empty document.files}">
                        <p class="no-files"><fmt:message key="doc.view.no_files"/></p>
                    </c:if>
                </div>
            </div>
            
            <div id="viewerModal" class="viewer-modal" onclick="if(event.target === this) closeViewer()">
                <div class="viewer-header">
                    <span class="viewer-title" id="viewerTitle"></span>
                    <div class="viewer-controls">
                        <button type="button" class="viewer-btn" onclick="zoomIn()" title="<fmt:message key="viewer.zoom_in"/>">+</button>
                        <button type="button" class="viewer-btn" onclick="zoomOut()" title="<fmt:message key="viewer.zoom_out"/>">−</button>
                        <button type="button" class="viewer-btn" onclick="resetZoom()" title="<fmt:message key="viewer.reset"/>">1:1</button>
                        <button type="button" class="viewer-btn viewer-close" onclick="closeViewer()" title="<fmt:message key="close"/>">✕ <fmt:message key="close"/></button>
                    </div>
                </div>
                <div class="viewer-body" id="viewerBody">
                    <img id="viewerImage" src="" alt="Document" onerror="this.style.display='none'; document.querySelector('.viewer-no-image').style.display='flex';" />
                    <div class="viewer-no-image" style="display:none; color:#6b7280; text-align:center;">
                        <svg viewBox="0 0 24 24" width="64" height="64"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                        <p class="no-preview-text"><fmt:message key="viewer.no_preview"/></p>
                        <a id="viewerDownloadLink" href="#" class="btn btn-primary no-preview-btn">
                            <svg viewBox="0 0 24 24" width="18" height="18"><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>
                            <fmt:message key="download"/>
                        </a>
                    </div>
                </div>
                <div class="viewer-nav">
                    <button type="button" class="viewer-nav-btn" id="prevBtn" onclick="prevImage()">←</button>
                    <span class="viewer-counter" id="viewerCounter"></span>
                    <button type="button" class="viewer-nav-btn" id="nextBtn" onclick="nextImage()">→</button>
                </div>
            </div>

            <div class="add-files-section">
                <h3><fmt:message key="doc.edit.add_new_files"/></h3>
                <form method="post" action="${pageContext.request.contextPath}/cabinet/documents/${document.id}/edit?lang=${pageContext.response.locale.language}" enctype="multipart/form-data" id="addFilesForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="title" value="${document.title}" />
                    <input type="hidden" name="description" value="${document.description}" />
                    <input type="hidden" name="doctorName" value="${document.doctorName}" />
                    
                    <div class="file-upload" id="fileDropZone">
                        <input type="file" name="newFiles" id="fileInput" multiple accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" onchange="updateFileList(this)" />
                        <div class="file-upload-content">
                            <div class="file-icon" id="fileIcon">
                                <svg viewBox="0 0 24 24"><path d="M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM14 13v4h-4v-4H7l5-5 5 5h-3z"/></svg>
                            </div>
                            <div class="file-info">
                                <span class="file-text" id="fileText"><fmt:message key="doc.form.drop_files"/></span>
                                <span class="file-hint"><fmt:message key="doc.form.file_hint"/></span>
                            </div>
                        </div>
                    </div>
                    <div class="selected-files" id="selectedFiles"></div>
                    <button type="submit" class="btn btn-primary" style="margin-top: 16px;">
                        <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                        <fmt:message key="doc.form.add_files"/>
                    </button>
                </form>
            </div>
        </div>
    </main>

    <style>
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        .files-section, .add-files-section {
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        .files-section h3, .add-files-section h3 {
            color: #fff;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        .files-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .file-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            background: rgba(0, 212, 170, 0.05);
            border: 1px solid rgba(0, 212, 170, 0.2);
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .file-item:hover {
            border-color: rgba(0, 212, 170, 0.4);
        }

        .file-item-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .file-item-icon svg {
            width: 18px !important;
            height: 18px !important;
            fill: #0a0e17;
        }

        .file-item-info {
            flex: 1;
            min-width: 0;
        }

        .file-item-name {
            display: block;
            color: #fff;
            font-size: 13px;
            font-weight: 500;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .file-item-size {
            display: block;
            color: #6b7280;
            font-size: 11px;
            margin-top: 2px;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 12px;
        }

        .btn-small svg {
            width: 14px !important;
            height: 14px !important;
        }

        .no-files {
            color: #6b7280;
            font-size: 14px;
            text-align: center;
            padding: 20px;
        }

        .file-upload {
            position: relative;
        }

        .file-upload input[type="file"] {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .file-upload-content {
            background: rgba(255, 255, 255, 0.03);
            border: 2px dashed rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .file-upload:hover .file-upload-content {
            border-color: #00d4aa;
            background: rgba(0, 212, 170, 0.05);
        }

        .file-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, rgba(0, 212, 170, 0.2) 0%, rgba(0, 163, 255, 0.2) 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
        }

        .file-icon svg {
            width: 24px;
            height: 24px;
            fill: #00d4aa;
        }

        .file-text {
            color: #fff;
            font-size: 14px;
            font-weight: 500;
            display: block;
            margin-bottom: 4px;
        }

        .file-hint {
            color: #6b7280;
            font-size: 12px;
        }

        .selected-files {
            margin-top: 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .selected-file {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            background: rgba(0, 212, 170, 0.05);
            border: 1px solid rgba(0, 212, 170, 0.2);
            border-radius: 8px;
        }

        .selected-file-icon {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .selected-file-icon svg {
            width: 16px;
            height: 16px;
            fill: #0a0e17;
        }

        .selected-file-name {
            flex: 1;
            color: #fff;
            font-size: 13px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .selected-file-size {
            color: #6b7280;
            font-size: 11px;
        }

        .btn-icon {
            width: 32px;
            height: 32px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-icon svg {
            width: 16px;
            height: 16px;
            fill: #6b7280;
        }

        .btn-icon.btn-delete:hover {
            background: rgba(239, 68, 68, 0.1);
            border-color: #ef4444;
        }

        .btn-icon.btn-delete:hover svg {
            fill: #ef4444;
        }

        @media (max-width: 600px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            .file-item {
                flex-wrap: wrap;
            }
            .file-item-info {
                order: 1;
                width: calc(100% - 48px);
            }
            .btn-small, .btn-icon {
                order: 2;
            }
        }

        .btn-view {
            background: rgba(0, 212, 170, 0.1);
            color: #00d4aa;
            border: 1px solid rgba(0, 212, 170, 0.3);
        }
        .btn-view:hover {
            background: rgba(0, 212, 170, 0.2);
        }
        .btn-view svg {
            width: 14px;
            height: 14px;
        }

        .viewer-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.95);
            z-index: 1000;
            flex-direction: column;
        }
        .viewer-modal.active {
            display: flex;
        }
        .viewer-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 24px;
            background: rgba(0, 0, 0, 0.5);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .viewer-title {
            color: #fff;
            font-size: 16px;
            font-weight: 500;
        }
        .viewer-controls {
            display: flex;
            gap: 8px;
        }
        .viewer-btn {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            color: #fff;
            font-size: 18px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }
        .viewer-btn:hover {
            background: rgba(0, 212, 170, 0.2);
            border-color: #00d4aa;
        }
        .viewer-close {
            background: rgba(239, 68, 68, 0.3) !important;
            border-color: #ef4444 !important;
            color: #fff !important;
            font-size: 20px;
            font-weight: bold;
        }
        .viewer-close:hover {
            background: rgba(239, 68, 68, 0.5) !important;
        }
        .viewer-body {
            flex: 1;
            overflow: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            cursor: grab;
        }
        .viewer-body:active {
            cursor: grabbing;
        }
        .viewer-body img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
            transition: transform 0.2s ease;
            user-select: none;
        }
        .viewer-body .viewer-no-image {
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .viewer-body .viewer-no-image svg {
            fill: #6b7280;
        }
        .viewer-body .no-preview-text {
            margin-top: 12px;
            font-size: 14px;
        }
        .viewer-body .no-preview-btn {
            margin-top: 12px;
        }
        .viewer-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 24px;
            background: rgba(0, 0, 0, 0.5);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        .viewer-nav-btn {
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .viewer-nav-btn:hover:not(:disabled) {
            background: rgba(0, 212, 170, 0.2);
            border-color: #00d4aa;
        }
        .viewer-nav-btn:disabled {
            opacity: 0.3;
            cursor: not-allowed;
        }
        .viewer-counter {
            color: #6b7280;
            font-size: 14px;
        }
    </style>

    <script>
        function updateFileList(input) {
            const container = document.getElementById('selectedFiles');
            const fileText = document.getElementById('fileText');
            
            if (input.files.length > 0) {
                fileText.textContent = '<fmt:message key="doc.form.files_selected"/>: ' + input.files.length;
                container.innerHTML = '';
                
                for (let i = 0; i < input.files.length; i++) {
                    const file = input.files[i];
                    const size = formatSize(file.size);
                    const div = document.createElement('div');
                    div.className = 'selected-file';
                    div.innerHTML = `
                        <div class="selected-file-icon">
                            <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                        </div>
                        <span class="selected-file-name">${file.name}</span>
                        <span class="selected-file-size">${size}</span>
                    `;
                    container.appendChild(div);
                }
            } else {
                fileText.textContent = '<fmt:message key="doc.form.drop_files"/>';
                container.innerHTML = '';
            }
        }

        function formatSize(bytes) {
            if (bytes < 1024) return bytes + ' B';
            if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
            return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
        }

        const files = [
            <c:forEach var="file" items="${document.files}" varStatus="status">
                { id: ${file.id}, name: "${file.fileName}", url: "${pageContext.request.contextPath}/cabinet/documents/${document.id}/download/${file.id}" }
                ${status.last ? '' : ','}
            </c:forEach>
        ];
        
        let currentIndex = 0;
        let currentZoom = 1;

        function openViewer(index) {
            currentIndex = index;
            currentZoom = 1;
            updateViewer();
            document.getElementById('viewerModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeViewer() {
            document.getElementById('viewerModal').classList.remove('active');
            document.body.style.overflow = '';
        }

        function updateViewer() {
            const file = files[currentIndex];
            const viewerImage = document.getElementById('viewerImage');
            const noImageDiv = document.querySelector('.viewer-no-image');
            const downloadLink = document.getElementById('viewerDownloadLink');
            
            viewerImage.style.display = 'block';
            noImageDiv.style.display = 'none';
            viewerImage.src = file.url;
            viewerImage.style.transform = 'scale(' + currentZoom + ')';
            document.getElementById('viewerTitle').textContent = file.name;
            document.getElementById('viewerCounter').textContent = (currentIndex + 1) + ' / ' + files.length;
            document.getElementById('prevBtn').disabled = currentIndex === 0;
            document.getElementById('nextBtn').disabled = currentIndex === files.length - 1;
            downloadLink.href = file.url;
            downloadLink.download = file.name;
        }

        function prevImage() {
            if (currentIndex > 0) {
                currentIndex--;
                currentZoom = 1;
                updateViewer();
            }
        }

        function nextImage() {
            if (currentIndex < files.length - 1) {
                currentIndex++;
                currentZoom = 1;
                updateViewer();
            }
        }

        function zoomIn() {
            currentZoom = Math.min(currentZoom + 0.25, 3);
            document.getElementById('viewerImage').style.transform = 'scale(' + currentZoom + ')';
        }

        function zoomOut() {
            currentZoom = Math.max(currentZoom - 0.25, 0.25);
            document.getElementById('viewerImage').style.transform = 'scale(' + currentZoom + ')';
        }

        function resetZoom() {
            currentZoom = 1;
            document.getElementById('viewerImage').style.transform = 'scale(1)';
        }

        document.addEventListener('keydown', function(e) {
            if (!document.getElementById('viewerModal').classList.contains('active')) return;
            if (e.key === 'Escape') closeViewer();
            if (e.key === 'ArrowLeft') prevImage();
            if (e.key === 'ArrowRight') nextImage();
            if (e.key === '+' || e.key === '=') zoomIn();
            if (e.key === '-') zoomOut();
        });

        document.getElementById('viewerBody').addEventListener('wheel', function(e) {
            e.preventDefault();
            if (e.deltaY < 0) zoomIn();
            else zoomOut();
        });
    </script>
</body>
</html>
