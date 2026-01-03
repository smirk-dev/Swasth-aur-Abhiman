# File Upload API Documentation

## Overview

The backend now supports professional content uploads for all domains (Skills, Health, Nutrition, etc.) with file handling, storage management, and comprehensive validation.

## Endpoints

### 1. Upload Media with File

**Endpoint:** `POST /admin/media/upload-file`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: multipart/form-data
```

**Body:**
- `file` (required): Video/content file (max 500MB)
- Form data fields:
  - `title` (string, required): Content title
  - `description` (string, required): Content description
  - `category` (enum, required): One of `MEDICAL`, `EDUCATION`, `SKILL`, `NUTRITION`
  - `subCategory` (string, optional): Profession-specific subcategory
  - `difficulty` (string, optional): `Beginner`, `Intermediate`, `Advanced`
  - `ageGroup` (string, optional): Target age/class group
  - `subject` (string, optional): Subject area
  - `chapter` (string, optional): Chapter reference
  - `language` (string, optional): `Hindi`, `English`, `Hinglish`
  - `durationSeconds` (number, optional): Video duration in seconds
  - `rating` (number, optional): 1.0-5.0
  - `isFree` (boolean, optional): Default true
  - `isActive` (boolean, optional): Default true

**Response:**
```json
{
  "id": "uuid",
  "title": "Bamboo Training Basics",
  "description": "Introduction to bamboo crafting",
  "category": "SKILL",
  "subCategory": "Bamboo Training",
  "mediaUrl": "/uploads/skill/filename.mp4",
  "source": "internal",
  "uploadedBy": {
    "id": "user-uuid",
    "email": "admin@example.com"
  },
  "createdAt": "2026-01-03T10:30:00Z"
}
```

---

### 2. Upload Media with Thumbnail

**Endpoint:** `POST /admin/media/upload-with-thumbnail`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: multipart/form-data
```

**Body:**
- `files` (required): Multiple files
  - Field `file`: Main content file (video, max 500MB)
  - Field `thumbnail`: Thumbnail image (JPEG/PNG/WebP, max 10MB)
- Same form data fields as endpoint 1

**Response:** Same as endpoint 1, with thumbnailUrl included

---

### 3. Bulk Upload Multiple Files

**Endpoint:** `POST /admin/media/bulk-upload`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: multipart/form-data
```

**Body:**
- `files` (required): Up to 10 files
- Form data array: `mediaDataList[]` - Array of media data objects (same fields as endpoint 1)

**Response:**
```json
{
  "totalAttempted": 5,
  "totalSuccessful": 4,
  "results": [
    {
      "success": true,
      "mediaId": "uuid",
      "title": "Bamboo Training"
    },
    {
      "success": true,
      "mediaId": "uuid",
      "title": "Honeybee Farming"
    },
    {
      "success": false,
      "fileName": "invalid.txt",
      "error": "File type not supported"
    }
  ]
}
```

---

## File Upload Examples

### Using cURL

#### Single File Upload
```bash
curl -X POST http://localhost:3000/admin/media/upload-file \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "file=@/path/to/video.mp4" \
  -F "title=Bamboo Training" \
  -F "description=Learn bamboo crafts" \
  -F "category=SKILL" \
  -F "subCategory=Bamboo Training" \
  -F "difficulty=Beginner" \
  -F "language=Hindi"
```

#### File with Thumbnail
```bash
curl -X POST http://localhost:3000/admin/media/upload-with-thumbnail \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "files=@/path/to/video.mp4" \
  -F "files=@/path/to/thumbnail.jpg" \
  -F "title=Honeybee Farming" \
  -F "description=Complete beekeeping guide" \
  -F "category=SKILL" \
  -F "subCategory=Honeybee Farming"
```

### Using JavaScript/Fetch

```javascript
const uploadFile = async (file, mediaData) => {
  const formData = new FormData();
  formData.append('file', file);
  
  // Add media data
  Object.entries(mediaData).forEach(([key, value]) => {
    if (value !== null && value !== undefined) {
      formData.append(key, value);
    }
  });

  const response = await fetch('/admin/media/upload-file', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`
    },
    body: formData
  });

  return response.json();
};

// Usage
await uploadFile(videoFile, {
  title: 'Bamboo Training',
  description: 'Learn bamboo crafts',
  category: 'SKILL',
  subCategory: 'Bamboo Training',
  difficulty: 'Beginner',
  language: 'Hindi'
});
```

### Using Axios

```javascript
const uploadWithAxios = async (file, mediaData) => {
  const formData = new FormData();
  formData.append('file', file);
  
  Object.entries(mediaData).forEach(([key, value]) => {
    if (value !== null && value !== undefined) {
      formData.append(key, value);
    }
  });

  const response = await axios.post(
    '/admin/media/upload-file',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': `Bearer ${token}`
      }
    }
  );

  return response.data;
};
```

---

## File Storage

### Directory Structure
```
backend/
├── uploads/
│   ├── skill/          # Skill training videos
│   ├── medical/        # Medical content
│   ├── education/      # Education videos
│   ├── nutrition/      # Nutrition guides
│   ├── skill-thumbnails/
│   ├── medical-thumbnails/
│   └── ...
```

### File Serving
All uploaded files are accessible via HTTP:
```
http://localhost:3000/uploads/skill/filename.mp4
```

---

## Validation & Constraints

### File Size Limits
- **Video files**: Maximum 500 MB
- **Thumbnail images**: Maximum 10 MB

### Allowed File Types
- **Videos**: MP4, WebM, MOV, AVI, MKV
- **Thumbnails**: JPEG, PNG, WebP

### Required Fields
- `title` (string)
- `description` (string)
- `category` (MEDICAL | EDUCATION | SKILL | NUTRITION)
- `file` (multipart file upload)

### Optional Profession-Specific Fields
- `difficulty`: Beginner | Intermediate | Advanced
- `ageGroup`: Class 1-12, Age groups
- `subject`: Mathematics, Science, Hindi, etc.
- `language`: Hindi, English, Hinglish
- `durationSeconds`: Video duration
- `rating`: 1.0-5.0 stars

---

## Error Handling

### Common Errors

**400 Bad Request** - Missing required fields
```json
{
  "statusCode": 400,
  "message": "File is required",
  "error": "Bad Request"
}
```

**413 Payload Too Large** - File exceeds size limit
```json
{
  "statusCode": 413,
  "message": "File size exceeds maximum limit of 500MB",
  "error": "Payload Too Large"
}
```

**415 Unsupported Media Type** - Invalid file type
```json
{
  "statusCode": 415,
  "message": "Only JPEG, PNG, and WebP images are allowed for thumbnails",
  "error": "Unsupported Media Type"
}
```

**401 Unauthorized** - Invalid JWT
```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

**403 Forbidden** - User is not admin
```json
{
  "statusCode": 403,
  "message": "Forbidden",
  "error": "Forbidden"
}
```

---

## Best Practices

1. **Always validate on frontend**
   - Check file size before upload
   - Validate file type
   - Show upload progress

2. **Handle large files**
   - Implement chunked uploads for videos >100MB
   - Show progress bar to user
   - Implement resume capability

3. **Thumbnail optimization**
   - Use WebP format for better compression
   - Generate thumbnails at 16:9 aspect ratio
   - Keep file under 5MB for fast loading

4. **Metadata**
   - Always include meaningful titles and descriptions
   - Use consistent category/subcategory naming
   - Add language and difficulty information

5. **Performance**
   - Compress videos before upload
   - Use CDN for file serving in production
   - Implement caching headers

---

## Migration from URL-based to File Uploads

### Before (URL-based)
```json
POST /admin/media/upload
{
  "title": "Bamboo Training",
  "mediaUrl": "https://example.com/video.mp4",
  "thumbnailUrl": "https://example.com/thumb.jpg"
}
```

### After (File-based)
```
POST /admin/media/upload-file
form-data:
  file: <binary>
  title: "Bamboo Training"
  category: "SKILL"
  subCategory: "Bamboo Training"
```

The new system is backward compatible - both methods work.

---

## Production Considerations

### For Large-Scale Deployment

1. **Cloud Storage (Recommended)**
   ```typescript
   // Add AWS S3 or similar
   // Update FileUploadService to use cloud storage
   ```

2. **Database Indexing**
   ```sql
   CREATE INDEX idx_media_category ON media_content(category);
   CREATE INDEX idx_media_upload_date ON media_content(createdAt);
   ```

3. **File Caching**
   - Add CloudFront/CDN distribution
   - Set appropriate cache headers
   - Implement lazy loading

4. **Monitoring**
   - Track upload success rates
   - Monitor storage usage
   - Alert on quota limits

---

## Related Endpoints

### Get Media
```
GET /admin/media?category=SKILL&page=1&limit=20
```

### Update Media
```
PUT /admin/media/:id
```

### Delete Media
```
DELETE /admin/media/:id
```

### Download/Export
```
GET /admin/media/export/csv
```
