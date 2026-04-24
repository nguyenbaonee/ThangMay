SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET time_zone = '+07:00';

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE product_view_logs;
TRUNCATE TABLE contact_requests;
TRUNCATE TABLE post_testimonials;
TRUNCATE TABLE product_specs;
TRUNCATE TABLE product_features;
TRUNCATE TABLE products;
TRUNCATE TABLE documents;
TRUNCATE TABLE posts;
TRUNCATE TABLE banners;
TRUNCATE TABLE company_contacts;
TRUNCATE TABLE media_files;
TRUNCATE TABLE refresh_tokens;
TRUNCATE TABLE user_roles;
TRUNCATE TABLE users;
TRUNCATE TABLE roles;
TRUNCATE TABLE product_categories;
TRUNCATE TABLE post_categories;
TRUNCATE TABLE document_categories;

SET FOREIGN_KEY_CHECKS = 1;

SET @ts = '2026-04-24 14:00:00.000000';
SET @media_ts = '2026-04-14 10:37:57.087321';

INSERT INTO roles (id, name, code, description, created_at, updated_at) VALUES
('r-admin', 'ROLE_ADMIN', 'ADMIN', 'Toan quyen he thong', @ts, @ts),
('r-editor', 'ROLE_EDITOR', 'EDITOR', 'Bien tap noi dung', @ts, @ts),
('r-client', 'ROLE_CLIENT', 'CLIENT', 'Khach hang', @ts, @ts),
('r-employee', 'ROLE_EMPLOYEE', 'EMPLOYEE', 'Nhan vien', @ts, @ts),
('r-sales', 'ROLE_SALES', 'SALES', 'Kinh doanh', @ts, @ts);

INSERT INTO users (id, username, email, password_hash, full_name, avatar_url, is_active, last_login_at, created_at, updated_at) VALUES
('u-admin', 'admin', 'admin@thangmaymisel.com', '$2a$12$JUkj3TzyCKNTYOSmFLT1aO7HDMnbYBNbLzQPCTr68e.DrkGFjR9MG', 'Administrator', NULL, 1, NULL, @ts, @ts),
('u-editor', 'editor', 'editor@thangmaymisel.com', '$2a$12$JUkj3TzyCKNTYOSmFLT1aO7HDMnbYBNbLzQPCTr68e.DrkGFjR9MG', 'Content Editor', NULL, 1, NULL, @ts, @ts),
('u-client', 'client', 'client@thangmaymisel.com', '$2a$12$JUkj3TzyCKNTYOSmFLT1aO7HDMnbYBNbLzQPCTr68e.DrkGFjR9MG', 'Customer Client', NULL, 1, NULL, @ts, @ts),
('u-employee', 'employee', 'employee@thangmaymisel.com', '$2a$12$JUkj3TzyCKNTYOSmFLT1aO7HDMnbYBNbLzQPCTr68e.DrkGFjR9MG', 'Field Employee', NULL, 1, NULL, @ts, @ts),
('u-sales', 'sales', 'sales@thangmaymisel.com', '$2a$12$JUkj3TzyCKNTYOSmFLT1aO7HDMnbLzQPCTr68e.DrkGFjR9MG', 'Sales Officer', NULL, 1, NULL, @ts, @ts);

INSERT INTO user_roles (user_id, role_id) VALUES
('u-admin', 'r-admin'),
('u-editor', 'r-editor'),
('u-client', 'r-client'),
('u-employee', 'r-employee'),
('u-sales', 'r-sales');

INSERT INTO refresh_tokens (id, user_id, token, expires_at, revoked, created_at) VALUES
('rt-01', 'u-admin', 'refresh-token-admin-001', DATE_ADD(@ts, INTERVAL 30 DAY), 0, @ts),
('rt-02', 'u-editor', 'refresh-token-editor-001', DATE_ADD(@ts, INTERVAL 30 DAY), 0, @ts),
('rt-03', 'u-client', 'refresh-token-client-001', DATE_ADD(@ts, INTERVAL 30 DAY), 0, @ts),
('rt-04', 'u-employee', 'refresh-token-employee-001', DATE_ADD(@ts, INTERVAL 30 DAY), 0, @ts),
('rt-05', 'u-sales', 'refresh-token-sales-001', DATE_ADD(@ts, INTERVAL 30 DAY), 0, @ts);

INSERT INTO media_files (id, uploaded_by, original_name, stored_name, bucket_name, object_key, public_url, content_type, file_size, alt_text, created_at, updated_at) VALUES
('5fac6cc7-eac5-481c-83b0-d57bff7726db', 'u-admin', 'tải xuống (1).jpg', 'd90adb01-5775-4c04-b5fa-ec56222ecf5f.jpg', 'bucket1', 'products/d90adb01-5775-4c04-b5fa-ec56222ecf5f.jpg', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf5f.jpg', 'image/jpeg', 7805, NULL, @media_ts, @media_ts),
('5fac6cc7-eac5-481c-83b0-d57bff7726dc', 'u-admin', 'product-02.jpg', 'd90adb01-5775-4c04-b5fa-ec56222ecf60.jpg', 'bucket1', 'products/d90adb01-5775-4c04-b5fa-ec56222ecf60.jpg', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf60.jpg', 'image/jpeg', 8120, NULL, @ts, @ts),
('5fac6cc7-eac5-481c-83b0-d57bff7726dd', 'u-admin', 'product-03.jpg', 'd90adb01-5775-4c04-b5fa-ec56222ecf61.jpg', 'bucket1', 'products/d90adb01-5775-4c04-b5fa-ec56222ecf61.jpg', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf61.jpg', 'image/jpeg', 8420, NULL, @ts, @ts),
('5fac6cc7-eac5-481c-83b0-d57bff7726de', 'u-admin', 'product-04.jpg', 'd90adb01-5775-4c04-b5fa-ec56222ecf62.jpg', 'bucket1', 'products/d90adb01-5775-4c04-b5fa-ec56222ecf62.jpg', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf62.jpg', 'image/jpeg', 9020, NULL, @ts, @ts),
('5fac6cc7-eac5-481c-83b0-d57bff7726df', 'u-admin', 'product-05.jpg', 'd90adb01-5775-4c04-b5fa-ec56222ecf63.jpg', 'bucket1', 'products/d90adb01-5775-4c04-b5fa-ec56222ecf63.jpg', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf63.jpg', 'image/jpeg', 9600, NULL, @ts, @ts);

INSERT INTO product_categories (id, name, slug, description, icon_url, sort_order, is_active, created_at, updated_at) VALUES
('pcat-01', 'Thang May Gia Dinh', 'thang-may-gia-dinh', 'Giai phap cho nha pho, villa va can ho', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf5f.jpg', 1, 1, @ts, @ts),
('pcat-02', 'Thang May Tai Khach', 'thang-may-tai-khach', 'Dung cho toa nha, van phong va khach san', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf60.jpg', 2, 1, @ts, @ts),
('pcat-03', 'Thang May Tai Hang', 'thang-may-tai-hang', 'Chuyen tai hang hoa trong kho xuong', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf61.jpg', 3, 1, @ts, @ts),
('pcat-04', 'Thang Cuon', 'thang-cuon', 'Luu thong dong nguoi trong trung tam thuong mai', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf62.jpg', 4, 1, @ts, @ts),
('pcat-05', 'Thang May Kinh', 'thang-may-kinh', 'Tang tinh tham my va tam nhin', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf63.jpg', 5, 1, @ts, @ts);

INSERT INTO products (id, category_id, created_by, name, slug, summary, description, thumbnail_id, image_ids, is_featured, is_active, view_count, sort_order, price, created_at, updated_at) VALUES
('prod-01', 'pcat-01', 'u-admin', 'Thang may gia dinh 450kg', 'thang-may-gia-dinh-450kg', 'Gon nhe, em ai, phu hop nha pho va villa.', '<p>Thang may gia dinh 450kg voi thiet ke hien dai, van hanh on dinh va tiet kiem dien nang.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726db', '5fac6cc7-eac5-481c-83b0-d57bff7726db;5fac6cc7-eac5-481c-83b0-d57bff7726dc', 1, 1, 0, 1, '450000000', @ts, @ts),
('prod-02', 'pcat-02', 'u-editor', 'Thang may tai khach 750kg', 'thang-may-tai-khach-750kg', 'Luu dong nhanh va an toan cho van phong, khach san.', '<p>Giai phap thang may tai khach 750kg, phu hop cong trinh van phong va trung tam dich vu.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726dc', '5fac6cc7-eac5-481c-83b0-d57bff7726dc;5fac6cc7-eac5-481c-83b0-d57bff7726dd', 1, 1, 0, 2, '680000000', @ts, @ts),
('prod-03', 'pcat-03', 'u-editor', 'Thang may tai hang 1000kg', 'thang-may-tai-hang-1000kg', 'Ben bi, chiu tai lon, phuc vu kho xuong.', '<p>Thang may tai hang 1000kg duoc toi uu cho kho logistics va nha may san xuat.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726dd', '5fac6cc7-eac5-481c-83b0-d57bff7726dd;5fac6cc7-eac5-481c-83b0-d57bff7726de', 0, 1, 0, 3, '780000000', @ts, @ts),
('prod-04', 'pcat-04', 'u-sales', 'Thang cuon trung tam 600mm', 'thang-cuon-trung-tam-600mm', 'Di chuyen lien tuc, phu hop trung tam thuong mai.', '<p>Thang cuon trung tam 600mm giup tang kha nang phuc vu luu luong nguoi lon.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726de', '5fac6cc7-eac5-481c-83b0-d57bff7726de;5fac6cc7-eac5-481c-83b0-d57bff7726df', 0, 1, 0, 4, '980000000', @ts, @ts),
('prod-05', 'pcat-05', 'u-admin', 'Thang may kinh panorama', 'thang-may-kinh-panorama', 'Noi bat ve mat do thi va khong gian sang trong.', '<p>Thang may kinh panorama mang lai cam giac sang trong, phu hop khach san va biet thu cao cap.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726df', '5fac6cc7-eac5-481c-83b0-d57bff7726df;5fac6cc7-eac5-481c-83b0-d57bff7726db', 1, 1, 0, 5, '1250000000', @ts, @ts);

INSERT INTO product_features (product_id, feature) VALUES
('prod-01', 'Van hanh em, tiet kiem dien'),
('prod-02', 'Tai trong on dinh cho nhieu nguoi'),
('prod-03', 'San go gang, ben bi trong moi truong kho'),
('prod-04', 'Thiet ke sang trong, luu thong lien tuc'),
('prod-05', 'Khong gian kinh panorama thong thoang');

INSERT INTO product_specs (id, product_id, spec_key, spec_value, unit, sort_order, created_at, updated_at) VALUES
('ps-01', 'prod-01', 'Tai trong', '450', 'kg', 1, @ts, @ts),
('ps-02', 'prod-02', 'Tai trong', '750', 'kg', 1, @ts, @ts),
('ps-03', 'prod-03', 'Tai trong', '1000', 'kg', 1, @ts, @ts),
('ps-04', 'prod-04', 'Duong kinh', '600', 'mm', 1, @ts, @ts),
('ps-05', 'prod-05', 'Bao hanh', '24', 'thang', 1, @ts, @ts);

INSERT INTO post_categories (id, name, slug, type, description, sort_order, is_active, created_at, updated_at) VALUES
('postcat-01', 'Tin tuc', 'tin-tuc', 'NEWS', 'Tin tuc moi nhat ve thang may', 1, 1, @ts, @ts),
('postcat-02', 'Du an tieu bieu', 'du-an-tieu-bieu', 'PROJECT', 'Cac du an da hoan thanh', 2, 1, @ts, @ts),
('postcat-03', 'Kien thuc', 'kien-thuc', 'BLOG', 'Kien thuc va kinh nghiem chuyen sau', 3, 1, @ts, @ts),
('postcat-04', 'Tuyen dung', 'tuyen-dung', 'RECRUITMENT', 'Co hoi viec lam', 4, 1, @ts, @ts),
('postcat-05', 'Cong nghe', 'cong-nghe', 'NEWS', 'Cong nghe va xu huong moi', 5, 1, @ts, @ts);

INSERT INTO posts (id, category_id, author_id, title, slug, summary, content, thumbnail_id, image_ids, type, status, is_featured, view_count, published_at, meta_title, meta_description, created_at, updated_at) VALUES
('post-01', 'postcat-01', 'u-editor', 'Cap nhat thi truong thang may 2026', 'cap-nhat-thi-truong-thang-may-2026', 'Tong hop cac xu huong noi bat.', '<p>Ban tin cap nhat ve xu huong thi truong thang may trong nam 2026.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726db', '5fac6cc7-eac5-481c-83b0-d57bff7726db;5fac6cc7-eac5-481c-83b0-d57bff7726dc', 'NEWS', 'PUBLISHED', 1, 0, @ts, 'Cap nhat thi truong thang may 2026', 'Tong hop cac xu huong noi bat.', @ts, @ts),
('post-02', 'postcat-02', 'u-admin', 'Du an biet thu hien dai', 'du-an-biet-thu-hien-dai', 'Du an thuc te cho biet thu cao cap.', '<p>Du an thuc te voi thang may kinh panorama cho biet thu hien dai.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726dc', '5fac6cc7-eac5-481c-83b0-d57bff7726dc;5fac6cc7-eac5-481c-83b0-d57bff7726dd', 'PROJECT', 'PUBLISHED', 1, 0, @ts, 'Du an biet thu hien dai', 'Du an thuc te cho biet thu cao cap.', @ts, @ts),
('post-03', 'postcat-03', 'u-editor', 'Toi uu khong gian cho nha pho', 'toi-uu-khong-gian-cho-nha-pho', 'Chia se kinh nghiem thiet ke.', '<p>Huong dan toi uu khong gian khi lap dat thang may gia dinh.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726dd', '5fac6cc7-eac5-481c-83b0-d57bff7726dd;5fac6cc7-eac5-481c-83b0-d57bff7726de', 'BLOG', 'PUBLISHED', 0, 0, @ts, 'Toi uu khong gian cho nha pho', 'Chia se kinh nghiem thiet ke.', @ts, @ts),
('post-04', 'postcat-04', 'u-sales', 'Tuyen dung ky su dien co dien', 'tuyen-dung-ky-su-dien-co-dien', 'Co hoi cho ung vien phu hop.', '<p>Dang tim ky su dien co dien co kinh nghiem lap dat va van hanh thang may.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726de', '5fac6cc7-eac5-481c-83b0-d57bff7726de;5fac6cc7-eac5-481c-83b0-d57bff7726df', 'RECRUITMENT', 'PUBLISHED', 0, 0, @ts, 'Tuyen dung ky su dien co dien', 'Co hoi cho ung vien phu hop.', @ts, @ts),
('post-05', 'postcat-05', 'u-admin', 'Cong nghe van hanh tiet kiem dien', 'cong-nghe-van-hanh-tiet-kiem-dien', 'Cong nghe moi trong nganh thang may.', '<p>Nhung xu huong cong nghe giup toi uu nang luong va tang do ben.</p>', '5fac6cc7-eac5-481c-83b0-d57bff7726df', '5fac6cc7-eac5-481c-83b0-d57bff7726df;5fac6cc7-eac5-481c-83b0-d57bff7726db', 'NEWS', 'PUBLISHED', 1, 0, @ts, 'Cong nghe van hanh tiet kiem dien', 'Cong nghe moi trong nganh thang may.', @ts, @ts);

INSERT INTO post_testimonials (id, post_id, customer_name, customer_title, content, rating, avatar_id, created_at, updated_at) VALUES
('pt-01', 'post-02', 'Anh Minh', 'Chu biet thu Riviera', 'Doi ngu thi cong rat chuyen nghiep va dung tien do.', 5, '5fac6cc7-eac5-481c-83b0-d57bff7726db', @ts, @ts),
('pt-02', 'post-02', 'Chi Thu', 'Giam doc KS Da Lat', 'Thiet ke sang trong, bao hanh chu dao.', 5, '5fac6cc7-eac5-481c-83b0-d57bff7726dc', @ts, @ts),
('pt-03', 'post-03', 'Anh Khoa', 'Chu nha pho Q7', 'Giai phap toan dien, lap dat gon gang.', 5, '5fac6cc7-eac5-481c-83b0-d57bff7726dd', @ts, @ts),
('pt-04', 'post-01', 'Chi Linh', 'Quan ly du an', 'Thong tin cap nhat ro rang, de theo doi.', 4, '5fac6cc7-eac5-481c-83b0-d57bff7726de', @ts, @ts),
('pt-05', 'post-05', 'Anh Nam', 'Ky su co dien', 'Cong nghe moi giup van hanh on dinh hon.', 5, '5fac6cc7-eac5-481c-83b0-d57bff7726df', @ts, @ts);

INSERT INTO document_categories (id, name, slug, sort_order, is_active, created_at, updated_at) VALUES
('dcat-01', 'Brochure san pham', 'brochure-san-pham', 1, 1, @ts, @ts),
('dcat-02', 'Tai lieu ky thuat', 'tai-lieu-ky-thuat', 2, 1, @ts, @ts),
('dcat-03', 'Huong dan su dung', 'huong-dan-su-dung', 3, 1, @ts, @ts),
('dcat-04', 'Huong dan bao tri', 'huong-dan-bao-tri', 4, 1, @ts, @ts),
('dcat-05', 'Ho so du an', 'ho-so-du-an', 5, 1, @ts, @ts);

INSERT INTO documents (id, category_id, uploaded_by, title, description, drive_url, file_type, file_size_kb, is_public, download_count, cover_image_id, created_at, updated_at) VALUES
('doc-01', 'dcat-01', 'u-admin', 'Brochure Thang may gia dinh', 'Tai lieu gioi thieu san pham.', 'https://example.com/docs/brochure-gia-dinh.pdf', 'PDF', 1024, 1, 0, '5fac6cc7-eac5-481c-83b0-d57bff7726db', @ts, @ts),
('doc-02', 'dcat-02', 'u-editor', 'Ban ve ky thuat 750kg', 'Thong so ky thuat chi tiet.', 'https://example.com/docs/ky-thuat-750kg.pdf', 'PDF', 2048, 1, 0, '5fac6cc7-eac5-481c-83b0-d57bff7726dc', @ts, @ts),
('doc-03', 'dcat-03', 'u-admin', 'Huong dan su dung co ban', 'Tai lieu danh cho nguoi su dung.', 'https://example.com/docs/huong-dan-su-dung.pdf', 'PDF', 1536, 1, 0, '5fac6cc7-eac5-481c-83b0-d57bff7726dd', @ts, @ts),
('doc-04', 'dcat-04', 'u-sales', 'Huong dan bao tri dinh ky', 'Lich bao tri va luu y an toan.', 'https://example.com/docs/bao-tri.pdf', 'PDF', 1792, 1, 0, '5fac6cc7-eac5-481c-83b0-d57bff7726de', @ts, @ts),
('doc-05', 'dcat-05', 'u-editor', 'Ho so du an mau', 'Bo ho so trinh bay du an mau.', 'https://example.com/docs/ho-so-du-an.pdf', 'PDF', 2304, 1, 0, '5fac6cc7-eac5-481c-83b0-d57bff7726df', @ts, @ts);

INSERT INTO contact_requests (id, full_name, phone, email, address, subject, message, source, status, assigned_to, note, contacted_at, created_at, updated_at) VALUES
('contact-01', 'Nguyen Van A', '0345986669', 'a@example.com', 'TP HCM', 'Bao gia thang may', 'Can bao gia cho nha pho 5 tang.', 'WEBSITE', 'NEW', 'u-sales', NULL, NULL, @ts, @ts),
('contact-02', 'Tran Thi B', '0912345678', 'b@example.com', 'Ha Noi', 'Tu van lap dat', 'Muon lap dat cho biet thu.', 'ZALO', 'CONTACTED', 'u-employee', 'Da goi dien', @ts, @ts, @ts),
('contact-03', 'Le Van C', '0987654321', NULL, 'Da Nang', 'Tai lieu ky thuat', 'Can tai lieu ky thuat 750kg.', 'FACEBOOK', 'DONE', 'u-editor', 'Da gui tai lieu', @ts, @ts, @ts),
('contact-04', 'Pham Thi D', '0901122334', 'd@example.com', 'Can Tho', 'Bao tri dinh ky', 'Can dich vu bao tri hang thang.', 'WEBSITE', 'CANCELLED', 'u-sales', 'Khach tam hoan', NULL, @ts, @ts),
('contact-05', 'Hoang Van E', '0933445566', 'e@example.com', 'Binh Duong', 'Lap dat thang cuon', 'Can lap dat cho trung tam thuong mai.', 'OTHER', 'NEW', 'u-employee', NULL, NULL, @ts, @ts);

INSERT INTO product_view_logs (id, product_id, ip_address, user_agent, viewed_at) VALUES
('view-01', 'prod-01', '127.0.0.1', 'Mozilla/5.0', @ts),
('view-02', 'prod-02', '127.0.0.2', 'Mozilla/5.0', @ts),
('view-03', 'prod-03', '127.0.0.3', 'Mozilla/5.0', @ts),
('view-04', 'prod-04', '127.0.0.4', 'Mozilla/5.0', @ts),
('view-05', 'prod-05', '127.0.0.5', 'Mozilla/5.0', @ts);

INSERT INTO company_contacts (id, config_key, config_value, label, is_active, updated_by, created_at, updated_at) VALUES
('cc-hotline', 'hotline', '034 598 6669', 'Hotline', 1, 'u-admin', @ts, @ts),
('cc-email', 'email', 'info@elevator.vn', 'Email', 1, 'u-admin', @ts, @ts),
('cc-address', 'address', '123 Duong ABC, Q.1, TP.HCM', 'Dia chi', 1, 'u-admin', @ts, @ts),
('cc-zalo', 'zalo_url', 'https://zalo.me/0345986669', 'Zalo', 1, 'u-admin', @ts, @ts),
('cc-facebook', 'facebook_url', 'https://facebook.com/elevator', 'Facebook', 1, 'u-admin', @ts, @ts);

INSERT INTO banners (id, title, image_url, link_url, position, sort_order, is_active, created_at, updated_at) VALUES
('banner-01', 'Banner TOP 1', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf5f.jpg', '/products', 'TOP', 1, 1, @ts, @ts),
('banner-02', 'Banner CENTER 1', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf60.jpg', '/products', 'CENTER', 1, 1, @ts, @ts),
('banner-03', 'Banner CENTER 2', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf61.jpg', '/projects', 'CENTER', 2, 1, @ts, @ts),
('banner-04', 'Banner MENU 1', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf62.jpg', '/contact', 'MENU', 1, 1, @ts, @ts),
('banner-05', 'Banner TOP 2', 'http://103.252.72.72:9000/bucket1/products/d90adb01-5775-4c04-b5fa-ec56222ecf63.jpg', '/documents', 'TOP', 2, 1, @ts, @ts);
