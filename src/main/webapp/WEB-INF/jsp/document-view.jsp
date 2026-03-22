<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>${document.title} - <fmt:message key="app.title"/></title>
    <%@ include file="fragments/common-styles.jsp" %>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet/documents?lang=${pageContext.response.locale.language}" class="back-link">
            <svg viewBox="0 0 24 24" width="20" height="20"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            <fmt:message key="back"/>
        </a>

        <div class="page-header">
            <h2>${document.title}</h2>
            <p><fmt:message key="doc.view.title"/></p>
        </div>

        <div class="card">
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label"><fmt:message key="doc.form.date"/></div>
                    <div class="info-value">${document.documentDateFormatted != '' ? document.documentDateFormatted : '—'}</div>
                </div>
                <div class="info-item">
                    <div class="info-label"><fmt:message key="doc.form.doctor"/></div>
                    <div class="info-value">${document.doctorName != '' ? document.doctorName : '—'}</div>
                </div>
                <div class="info-item">
                    <div class="info-label"><fmt:message key="doc.form.files"/></div>
                    <div class="info-value">${document.fileCount}</div>
                </div>
            </div>

            <c:if test="${not empty document.description}">
                <div class="info-section" style="margin-top: 20px;">
                    <h3 class="section-title">
                        <svg viewBox="0 0 24 24" width="20" height="20"><path d="M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm4 18H6V4h7v5h5v11z"/></svg>
                        <fmt:message key="doc.form.description"/>
                    </h3>
                    <p style="color: #e5e5e5; line-height: 1.6;">${document.description}</p>
                </div>
            </c:if>

            <div class="files-section">
                <h3><fmt:message key="doc.view.files"/> (${document.fileCount})</h3>
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
                        </div>
                    </c:forEach>
                    <c:if test="${empty document.files}">
                        <p class="no-files"><fmt:message key="doc.view.no_files"/></p>
                    </c:if>
                </div>
            </div>

            <c:if test="${document.isHasExtractedText}">
                <div class="info-section" style="margin-top: 24px; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.05);">
                    <h3 class="section-title">
                        <svg viewBox="0 0 24 24" width="20" height="20"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                        <fmt:message key="doc.view.ocr_text"/>
                    </h3>
                    <div style="background: rgba(0,212,170,0.05); border: 1px solid rgba(0,212,170,0.2); border-radius: 12px; padding: 16px; white-space: pre-wrap; font-size: 14px; line-height: 1.8; color: #e5e5e5;">${document.extractedText}</div>
                </div>
            </c:if>

            <c:if test="${document.isHasOcrError}">
                <div class="ocr-error" style="margin-top: 24px; padding: 20px; background: rgba(251,191,36,0.1); border: 1px solid rgba(251,191,36,0.3); border-radius: 12px; display: flex; align-items: flex-start; gap: 16px;">
                    <svg viewBox="0 0 24 24" width="32" height="32" style="fill:#fbbf24; flex-shrink:0;"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
                    <div>
                        <strong style="color:#fbbf24;display:block;margin-bottom:4px;"><fmt:message key="doc.view.ocr_error"/></strong>
                        <span style="color:#e5e5e5;font-size:14px;">${document.ocrError}</span>
                    </div>
                </div>
            </c:if>

            <div class="actions" style="margin-top: 24px; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.05); display: flex; gap: 12px; flex-wrap: wrap;">
                <c:if test="${document.isHasOcrError}">
                    <form method="post" action="${pageContext.request.contextPath}/cabinet/documents/${document.id}/retry-ocr" style="display:inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn btn-warning">
                            <svg viewBox="0 0 24 24" width="16" height="16"><path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/></svg>
                            <fmt:message key="doc.retry_ocr"/>
                        </button>
                    </form>
                </c:if>
                <a href="${pageContext.request.contextPath}/cabinet/documents/${document.id}/edit?lang=${pageContext.response.locale.language}" class="btn btn-outline">
                    <svg viewBox="0 0 24 24" width="16" height="16"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                    <fmt:message key="edit"/>
                </a>
                <form method="post" action="${pageContext.request.contextPath}/cabinet/documents/${document.id}/delete" style="display:inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-danger" onclick="return confirm('<fmt:message key="doc.view.delete_confirm"/>')">
                        <svg viewBox="0 0 24 24" width="16" height="16"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                        <fmt:message key="delete"/>
                    </button>
                </form>
            </div>
        </div>
    </main>

    <div id="viewerModal" class="viewer-modal" onclick="if(event.target === this) closeViewer()">
        <div class="viewer-header">
            <span class="viewer-title" id="viewerTitle"></span>
            <div class="viewer-controls">
                <button type="button" class="viewer-btn" onclick="zoomIn()">+</button>
                <button type="button" class="viewer-btn" onclick="zoomOut()">−</button>
                <button type="button" class="viewer-btn" onclick="resetZoom()">1:1</button>
                <button type="button" class="viewer-btn viewer-close" onclick="closeViewer()">X</button>
            </div>
        </div>
        <div class="viewer-body" id="viewerBody">
            <img id="viewerImage" src="" alt="Document" onerror="this.style.display='none'; document.getElementById('noPreview').style.display='flex';" />
            <div id="noPreview" style="display:none; flex-direction:column; align-items:center; justify-content:center; color:#6b7280; text-align:center; min-height:200px;">
                <svg viewBox="0 0 24 24" width="64" height="64" style="fill:#6b7280;"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                <p style="margin-top:12px; font-size:14px;"><fmt:message key="viewer.no_preview"/></p>
                <a id="viewerDownloadLink" href="#" class="btn btn-primary" style="margin-top:12px;" download>
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

    <style>
        .file-item-icon {
            width: 36px !important;
            height: 36px !important;
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
        .btn-small { padding: 6px 12px; font-size: 12px; }
        .btn-small svg { width: 14px !important; height: 14px !important; fill: currentColor; }
        .btn svg { width: 16px !important; height: 16px !important; fill: currentColor; vertical-align: middle; margin-right: 6px; }
        .btn-warning, .btn-danger { background: rgba(0,0,0,0.2); border: 1px solid; }
        .btn-warning { color: #fbbf24; border-color: rgba(251,191,36,0.3); }
        .btn-danger { color: #f87171; border-color: rgba(239,68,68,0.3); }
        .btn-view { background: rgba(0,212,170,0.1); color: #00d4aa; border: 1px solid rgba(0,212,170,0.3); cursor: pointer; }
        .btn-view:hover { background: rgba(0,212,170,0.3); border-color: #00d4aa; }
        .info-section { margin-bottom: 20px; }
        .files-section { margin-top: 24px; }
        .files-section h3 { color: #fff; font-size: 16px; font-weight: 600; margin-bottom: 16px; }
        .files-list { display: flex; flex-direction: column; gap: 10px; }
        .file-item { display: flex; align-items: center; gap: 12px; padding: 12px 14px; background: rgba(0,212,170,0.05); border: 1px solid rgba(0,212,170,0.2); border-radius: 10px; }
        .file-item:hover { border-color: rgba(0,212,170,0.4); }
        .file-item-info { flex: 1; min-width: 0; }
        .file-item-name { display: block; color: #fff; font-size: 13px; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .file-item-size { display: block; color: #6b7280; font-size: 11px; margin-top: 2px; }
        .no-files { color: #6b7280; font-size: 14px; text-align: center; padding: 20px; }
        .viewer-modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.95); z-index: 1000; flex-direction: column; }
        .viewer-modal.active { display: flex; }
        .viewer-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; background: rgba(0,0,0,0.5); border-bottom: 1px solid rgba(255,255,255,0.1); }
        .viewer-title { color: #fff; font-size: 16px; font-weight: 500; }
        .viewer-controls { display: flex; gap: 8px; }
        .viewer-btn { width: 40px; height: 40px; background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2); border-radius: 8px; color: #fff; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.2s ease; }
        .viewer-btn:hover { background: rgba(0,212,170,0.2); border-color: #00d4aa; }
        .viewer-close { width: auto; padding: 0 12px; font-size: 14px; background: rgba(239,68,68,0.3); border-color: #ef4444; }
        .viewer-close:hover { background: rgba(239,68,68,0.5); border-color: #ef4444; }
        .viewer-body { flex: 1; overflow: auto; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .viewer-body img { max-width: 100%; max-height: 100%; object-fit: contain; }
        .viewer-nav { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; background: rgba(0,0,0,0.5); border-top: 1px solid rgba(255,255,255,0.1); }
        .viewer-nav-btn { padding: 10px 20px; background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2); border-radius: 8px; color: #fff; font-size: 14px; cursor: pointer; }
        .viewer-nav-btn:hover:not(:disabled) { background: rgba(0,212,170,0.2); border-color: #00d4aa; }
        .viewer-nav-btn:disabled { opacity: 0.3; cursor: not-allowed; }
        .viewer-counter { color: #6b7280; font-size: 14px; }
    </style>

    <script>
        // Force reload by adding timestamp
        window.lastViewLoad = Date.now();
        
        var files = [
            <c:forEach var="file" items="${document.files}" varStatus="status">
                { id: '${file.id}', name: '<c:out value="${file.fileName}" escapeXml="true"/>', url: '${pageContext.request.contextPath}/cabinet/documents/${document.id}/preview/${file.id}', downloadUrl: '${pageContext.request.contextPath}/cabinet/documents/${document.id}/download/${file.id}' }
                ${status.last ? '' : ','}
            </c:forEach>
        ];
        
        var currentIndex = 0;
        var currentZoom = 1;

        function openViewer(index) {
            if (typeof files !== 'undefined' && files.length > 0) {
                currentIndex = index;
                currentZoom = 1;
                updateViewer();
                document.getElementById('viewerModal').classList.add('active');
                document.body.style.overflow = 'hidden';
            }
        }

        function closeViewer() {
            document.getElementById('viewerModal').classList.remove('active');
            document.body.style.overflow = '';
        }

        function updateViewer() {
            if (typeof files === 'undefined' || files.length === 0) return;
            var file = files[currentIndex];
            var img = document.getElementById('viewerImage');
            var noPreview = document.getElementById('noPreview');
            var downloadLink = document.getElementById('viewerDownloadLink');
            
            img.style.display = 'block';
            noPreview.style.display = 'none';
            img.src = file.url;
            img.style.transform = 'scale(' + currentZoom + ')';
            document.getElementById('viewerTitle').textContent = file.name;
            document.getElementById('viewerCounter').textContent = (currentIndex + 1) + ' / ' + files.length;
            document.getElementById('prevBtn').disabled = currentIndex === 0;
            document.getElementById('nextBtn').disabled = currentIndex === files.length - 1;
            downloadLink.href = file.downloadUrl;
            downloadLink.download = file.name;
        }

        function prevImage() {
            if (currentIndex > 0) { currentIndex--; currentZoom = 1; updateViewer(); }
        }

        function nextImage() {
            if (currentIndex < files.length - 1) { currentIndex++; currentZoom = 1; updateViewer(); }
        }

        function zoomIn() { currentZoom = Math.min(currentZoom + 0.25, 3); document.getElementById('viewerImage').style.transform = 'scale(' + currentZoom + ')'; }
        function zoomOut() { currentZoom = Math.max(currentZoom - 0.25, 0.25); document.getElementById('viewerImage').style.transform = 'scale(' + currentZoom + ')'; }
        function resetZoom() { currentZoom = 1; document.getElementById('viewerImage').style.transform = 'scale(1)'; }

        document.addEventListener('keydown', function(e) {
            if (!document.getElementById('viewerModal').classList.contains('active')) return;
            if (e.key === 'Escape') closeViewer();
            if (e.key === 'ArrowLeft') prevImage();
            if (e.key === 'ArrowRight') nextImage();
        });
    </script>
</body>
</html>
