USE bookstore;
# 4.1.	Tạo trigger tr_Check_total_book_author sao cho khi thêm Book nếu Author đang tham chiếu có tổng số sách > 5 thì
# không cho thêm mới và thông báo “Tác giả này có số lượng sách đạt tới giới hạn 5 cuốn, vui long chọn tác giả khác”
DELIMITER //
CREATE TRIGGER tr_Check_total_book_author
    BEFORE INSERT
    ON Book
    FOR EACH ROW
BEGIN
    DECLARE book_count INT;

    SELECT COUNT(AuthorId) INTO book_count FROM Book WHERE AuthorId = NEW.AuthorId;

    IF book_count >= 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Tác giả này có số lượng sách đã đạt tới giới hạn 5 cuốn, vui lòng chọn tác giả khác';
    END IF;
END //
DELIMITER ;

# 4.2.	Tạo trigger tr_Update_TotalBook khi thêm mới Book thì cập nhật cột TotalBook rong bảng Author = tổng của Book theo AuthorId
DELIMITER //
CREATE TRIGGER tr_Update_TotalBook
    after INSERT
    ON Book
    FOR EACH ROW
BEGIN
    UPDATE Author
    SET TotalBook = (SELECT COUNT(*)
                     FROM Book
                     WHERE Book.AuthorId = Author.Id);
END //
DELIMITER ;
