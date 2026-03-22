package com.hackaton.controller;

import com.hackaton.model.DocumentFile;
import com.hackaton.model.MedicalDocument;
import com.hackaton.model.User;
import com.hackaton.service.MedicalDocumentService;
import com.hackaton.service.UserService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
public class DocumentController {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final MedicalDocumentService documentService;
    private final UserService userService;

    @Value("${freemium.document.limit:5}")
    private int freemiumLimit;

    public DocumentController(MedicalDocumentService documentService, UserService userService) {
        this.documentService = documentService;
        this.userService = userService;
    }

    @GetMapping("/cabinet/documents")
    public String documents(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }
        List<MedicalDocument> documents = documentService.getDocumentsByUserId(user.getId());
        if (documents == null) {
            documents = new java.util.ArrayList<>();
        }
        boolean isPremium = user.isPremiumActive();
        boolean limitReached = !isPremium && documents.size() >= freemiumLimit;
        
        model.addAttribute("email", email);
        model.addAttribute("lastName", user.getLastName());
        model.addAttribute("firstName", user.getFirstName());
        model.addAttribute("documents", documents);
        model.addAttribute("isPremium", isPremium);
        model.addAttribute("freemiumLimit", freemiumLimit);
        model.addAttribute("limitReached", limitReached);
        model.addAttribute("documentCount", documents.size());
        return "documents";
    }

    @GetMapping("/cabinet/documents/new")
    public String newDocument(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }
        
        List<MedicalDocument> documents = documentService.getDocumentsByUserId(user.getId());
        boolean isPremium = user.isPremiumActive();
        boolean limitReached = !isPremium && documents.size() >= freemiumLimit;
        
        if (limitReached) {
            return "redirect:/payment/upgrade";
        }
        
        model.addAttribute("email", email);
        model.addAttribute("lastName", user.getLastName());
        model.addAttribute("firstName", user.getFirstName());
        model.addAttribute("today", LocalDate.now().format(DATE_FORMATTER));
        return "document-upload";
    }

    @PostMapping("/cabinet/documents")
    public String createDocument(
            Authentication authentication,
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String documentDate,
            @RequestParam(required = false) String doctorName,
            @RequestParam(required = false) String sessionId,
            @RequestParam List<MultipartFile> files
    ) throws IOException {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }

        LocalDate date = documentDate != null && !documentDate.isEmpty() 
            ? LocalDate.parse(documentDate, DATE_FORMATTER) 
            : null;

        documentService.createDocument(user.getId(), title, description, date, doctorName, files);
        return "redirect:/cabinet/documents?created=true";
    }

    @GetMapping("/cabinet/documents/{id}/view")
    public String viewDocument(@PathVariable Long id, Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }

        Optional<MedicalDocument> doc = documentService.getDocumentByIdAndUserId(id, user.getId());
        if (doc.isEmpty()) {
            return "redirect:/cabinet/documents";
        }
        
        model.addAttribute("document", doc.get());
        model.addAttribute("email", email);
        model.addAttribute("lastName", user.getLastName());
        model.addAttribute("firstName", user.getFirstName());
        return "document-view";
    }

    @GetMapping("/cabinet/documents/{id}/download/{fileId}")
    public ResponseEntity<byte[]> downloadFile(@PathVariable Long id, @PathVariable Long fileId, Authentication authentication) throws IOException {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        Optional<MedicalDocument> docOpt = documentService.getDocumentByIdAndUserId(id, user.getId());
        if (docOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        MedicalDocument doc = docOpt.get();
        Optional<DocumentFile> fileOpt = doc.getFiles().stream()
            .filter(f -> f.getId().equals(fileId))
            .findFirst();
        
        if (fileOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        DocumentFile file = fileOpt.get();
        Path filePath = Paths.get(documentService.getUploadDir() + file.getFilePath());
        
        if (!Files.exists(filePath)) {
            return ResponseEntity.notFound().build();
        }

        byte[] fileContent = Files.readAllBytes(filePath);

        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFileName() + "\"")
            .contentType(MediaType.APPLICATION_OCTET_STREAM)
            .body(fileContent);
    }

    @GetMapping("/cabinet/documents/{id}/edit")
    public String editDocument(@PathVariable Long id, Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }

        Optional<MedicalDocument> doc = documentService.getDocumentByIdAndUserId(id, user.getId());
        if (doc.isEmpty()) {
            return "redirect:/cabinet/documents";
        }
        
        model.addAttribute("document", doc.get());
        model.addAttribute("email", email);
        model.addAttribute("lastName", user.getLastName());
        model.addAttribute("firstName", user.getFirstName());
        return "document-edit";
    }

    @PostMapping("/cabinet/documents/{id}/edit")
    public String updateDocument(
            @PathVariable Long id,
            Authentication authentication,
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String documentDate,
            @RequestParam(required = false) String doctorName,
            @RequestParam(required = false) List<MultipartFile> newFiles
    ) throws IOException {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }

        LocalDate date = documentDate != null && !documentDate.isEmpty() 
            ? LocalDate.parse(documentDate, DATE_FORMATTER) 
            : null;

        documentService.updateDocument(id, user.getId(), title, description, date, doctorName, newFiles);
        return "redirect:/cabinet/documents/" + id + "?updated=true";
    }

    @PostMapping("/cabinet/documents/{id}/deletefile/{fileId}")
    public String deleteFile(@PathVariable Long id, @PathVariable Long fileId, Authentication authentication) throws IOException {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }

        documentService.deleteDocumentFile(id, fileId, user.getId());
        return "redirect:/cabinet/documents/" + id + "/edit";
    }

    @PostMapping("/cabinet/documents/{id}/delete")
    public String deleteDocument(@PathVariable Long id, Authentication authentication) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }

        documentService.deleteDocument(id, user.getId());
        return "redirect:/cabinet/documents?deleted=true";
    }

    @PostMapping("/cabinet/documents/{id}/retry-ocr")
    public String retryOcr(@PathVariable Long id, Authentication authentication) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        if (user == null) {
            return "redirect:/auth/login";
        }

        try {
            documentService.retryOcr(id, user.getId());
        } catch (Exception e) {
            // Error will be saved to DB
        }
        return "redirect:/cabinet/documents/" + id;
    }
}
