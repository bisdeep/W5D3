require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
include Singleton

    def initialize
        super('./../questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end


class UserModel
    attr_accessor :fname, :lname, :id
    
    def self.find_by_id(userid)
        user = QuestionsDBConnection.instance.execute(<<-SQL, userid)
            SELECT * FROM user
            WHERE id = ?
        SQL
        return nil unless user.length > 0

        UserModel.new(user)
    end

    def self.find_by_name(fname, lname)
        user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT * FROM user
            WHERE fname = ? 
            AND lname = ?
        SQL
        return nil unless user.length > 0

        UserModel.new(user)
    end

    def self.all
        users = QuestionsDBConnection.instance.execute("SELECT * FROM user")
        #this returns us multiple users in an array, so iterate through
        #make Models out of each user
        users.map do |user|
            UserModel.new(user)
        end
    end

    def initialize(options)
        @id = options["id"]
        @fname = options["fname"]
        @lname = options["lname"]
    end

    def authored_questions(user_id)
        authored_questions = QuestionModel.find_by_author_id(user_id)
        # questions = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
        #     SELECT * FROM questions
        #     WHERE author_id = ?
        #     SQL
    end

    def authored_replies(user_id)
        authored_replies = RepliesModel.find_by_user_id(user_id)
        # questions = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
        #     SELECT * FROM questions
        #     WHERE author_id = ?
        #     SQL
    end

end

class QuestionModel

    attr_accessor :id, :title, :body, :author_id

    def self.find_by_author_id(author_id)
        questions = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
            SELECT * FROM questions
            WHERE author_id = ?
        SQL
        return nil unless questions.length > 0
        questions.map { |question| QuestionModel.new(question)}
    end

    def self.find_by_id(questionid)
        question = QuestionsDBConnection.instance.execute(<<-SQL, questionid)
            SELECT * FROM questions
            WHERE id = ?
        SQL
        return nil unless question.length > 0

        QuestionModel.new(question)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    # def create
    #     #raise "error" if self.id

    #     QuestionsDBConnection.instance.execute(<<-SQL, self.title, self.body, self.author_id, self.id)
    #         INSERT INTO
    #             questions(title, body, author_id)
    #         VALUES
    #             (?, ?, ?)
    #     SQL
    #     self.id = QuestionsDBConnection.instance.last_insert_row_id
    # end

    def author
        authors = QuestionsDBConnection.instance.execute(<<-SQL, self.author_id)
            SELECT fname, lname FROM user
            WHERE id = ?
        SQL

        return nil if authors.length < 0
        UserModel.new(authors.first)
    end

    def replies
        replies = RepliesModel.find_by_question_id(self.id)
    end

end

class QuestionFollowsModel
    attr_accessor :id, :user_id, :question_id

    def self.find_by_id(questionid)
        question = QuestionsDBConnection.instance.execute(<<-SQL, questionid)
            SELECT * FROM question_follows
            WHERE id = ?
        SQL
        return nil unless question.length > 0

        QuestionFollowsModel.new(question)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end

class RepliesModel
    attr_accessor :id, :user_id, :question_id, :parent_reply_id, :body

    def self.find_by_user_id(user_id)
       users = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
        SELECT * FROM users
        WHERE id = ?
       SQL

       return nil unless users.length > 0
       users.map{|user| RepliesModel.new(user)}

    end

    def self.find_by_question_id(question_id)
        questions = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
            SELECT * FROM questions
            WHERE id = ?
       SQL
       return nil unless questions.length > 0
       questions.map{|question| RepliesModel.new(question)}

    end

    def self.find_by_id(replyid)
        reply = QuestionsDBConnection.instance.execute(<<-SQL, replyid)
            SELECT * FROM replies
            WHERE id = ?
        SQL
        return nil unless reply.length > 0

        RepliesModel.new(reply)
    end

    def initialize(options)
        @id = options['id']
        @parent_reply_id = options['parent_reply_id']
        @question_id = options['question_id']
        @user_id = options['user_id']
        @body = options['body'] 
    end

    def author
        authors = QuestionsDBConnection.instance.execute(<<-SQL, self.user_id)
            SELECT fname, lname FROM user
            WHERE id = ?
        SQL

        return nil if authors.length < 0
        UserModel.new(authors.first)
    end



end

class QuestionLikesModel
    attr_accessor :id, :user_id, :question_id

    def self.find_by_id(qlikesid)
        like = QuestionsDBConnection.instance.execute(<<-SQL, qlikesid)
            SELECT * FROM question_likes
            WHERE id = ?
        SQL
        return nil unless like.length > 0

        QuestionLikesModel.new(like)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end






