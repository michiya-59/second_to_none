# frozen_string_literal: true

class UserIntroducerGradeUpdater
  def initialize user
    @user = user
  end

  def update_introducer_grades
    update_grade_for @user.introducer_id
    update_grade_for_parent_of @user.introducer_id
  end

  private

  def update_grade_for introducer_id
    return unless introducer_id

    introducer_datas = Relationship.where(parent_id: introducer_id)
    introducer_introduction_count = count_second_level_introductions introducer_datas

    main_user = User.find(introducer_id)
    return if main_user.blank?

    update_user_grade main_user, introducer_datas.count, introducer_introduction_count
  end

  def update_grade_for_parent_of child_id
    parent_id = Relationship.find_by(child_id:)&.parent_id
    update_grade_for parent_id
  end

  def count_second_level_introductions introducer_datas
    introducer_datas.sum do |introducer_data|
      Relationship.where(parent_id: introducer_data&.child_id).count
    end
  end

  def update_user_grade main_user, first_level_count, second_level_count
    if first_level_count >= 12 && second_level_count >= 12
      if main_user.grade_id != Grade::GRADE[:emerald]
        main_user.update(grade_id: Grade::GRADE[:emerald])
      end
    elsif first_level_count >= 6 && second_level_count >= 4
      main_user.update(grade_id: Grade::GRADE[:ruby]) if main_user.grade_id != Grade::GRADE[:ruby]
    elsif first_level_count >= 3
      if main_user.grade_id != Grade::GRADE[:normal]
        main_user.update(grade_id: Grade::GRADE[:normal])
      end
    end
  end
end
