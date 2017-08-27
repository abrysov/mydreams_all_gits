package com.mydreams.android.utils;

import android.content.Context;
import android.support.annotation.IntegerRes;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;

import com.annimon.stream.Stream;
import com.mydreams.android.R;

import org.apache.commons.lang3.StringUtils;

import java.util.regex.Pattern;

public class StringValidator
{
	public static final StringValidator FirstNameValidator = new StringValidator(
			new StringValidator.IsNonBlankRule(R.string.enter_first_name_error_message),
			new StringValidator.LengthRule(R.integer.min_first_name_length, R.integer.max_first_name_length, R.string.length_first_name_error_message_format, true));

	public static final StringValidator LastNameValidator = new StringValidator(
			new StringValidator.LengthRule(R.integer.min_last_name_length, R.integer.max_last_name_length, R.string.length_last_name_error_message_format, true));

	public static final StringValidator EmailValidator = new StringValidator(
			new StringValidator.IsNonBlankRule(R.string.enter_email_error_message),
			new StringValidator.EmailRule(R.string.enter_valid_email_error_message));

	public static final StringValidator PhoneValidator = new StringValidator(
			new StringValidator.PatternRule("^[+0-9\\(\\)\\ ]*$", R.string.invalid_chars_phone_error_message),
			new StringValidator.LengthRule(R.integer.min_phone_length, R.integer.max_phone_length, R.string.length_phone_error_message_format, true));

	public static final StringValidator PasswordValidator = new StringValidator(
			new StringValidator.IsNonBlankRule(R.string.enter_password_error_message),
			new StringValidator.HasAlphaRule(R.string.password_must_contain_letter),
			new StringValidator.LengthRule(R.integer.min_password_length, R.integer.max_password_length, R.string.length_password_error_message_format, true));

	private IRule[] mRules;

	public StringValidator(@NonNull IRule... rules)
	{
		mRules = rules;
	}

	@Nullable
	public String validate(@NonNull Context context, @Nullable String value)
	{
		return Stream.of(mRules)
				.map(x -> x.validate(context, value))
				.filter(x -> x != null)
				.findFirst()
				.orElse(null);
	}

	public interface IRule
	{
		@Nullable
		String validate(@NonNull Context context, @Nullable String value);
	}

	public static class IsNonEmptyRule implements IRule
	{
		@StringRes
		private int mErrorId;

		public IsNonEmptyRule(@StringRes int errorId)
		{
			this.mErrorId = errorId;
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			return StringUtils.isEmpty(value) ? context.getString(mErrorId) : null;
		}
	}

	public static class IsNonBlankRule implements IRule
	{
		@StringRes
		private int mErrorId;

		public IsNonBlankRule(@StringRes int errorId)
		{
			this.mErrorId = errorId;
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			return StringUtils.isBlank(value) ? context.getString(mErrorId) : null;
		}
	}

	public static class LengthRule implements IRule
	{
		@IntegerRes
		private int mMinId;
		@IntegerRes
		private int mMaxId;
		@StringRes
		private int mErrorId;
		private boolean nUseFormat;

		public LengthRule(@IntegerRes int minId, @IntegerRes int maxId, @StringRes int errorId, boolean useFormat)
		{
			this.mMinId = minId;
			this.mMaxId = maxId;
			this.mErrorId = errorId;
			this.nUseFormat = useFormat;
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			int min = context.getResources().getInteger(mMinId);
			int max = context.getResources().getInteger(mMaxId);

			if (value == null || value.length() < min || value.length() > max)
			{
				return nUseFormat ? context.getString(mErrorId, min, max) : context.getString(mErrorId);
			}

			return null;
		}
	}

	public static class MinLengthRule implements IRule
	{
		@IntegerRes
		private int mMinId;
		@StringRes
		private int mErrorId;
		private boolean nUseFormat;

		public MinLengthRule(@IntegerRes int minId, @StringRes int errorId, boolean useFormat)
		{
			this.mMinId = minId;
			this.mErrorId = errorId;
			this.nUseFormat = useFormat;
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			int min = context.getResources().getInteger(mMinId);
			if (value == null || value.length() < min)
			{
				return nUseFormat ? context.getString(mErrorId, min) : context.getString(mErrorId);
			}

			return null;
		}
	}

	public static class MaxLengthRule implements IRule
	{
		@IntegerRes
		private int mMaxId;
		@StringRes
		private int mErrorId;
		private boolean nUseFormat;

		public MaxLengthRule(@IntegerRes int maxId, @StringRes int errorId, boolean useFormat)
		{
			this.mMaxId = maxId;
			this.mErrorId = errorId;
			this.nUseFormat = useFormat;
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			int max = context.getResources().getInteger(mMaxId);
			if (value == null || value.length() > max)
			{
				return nUseFormat ? context.getString(mErrorId, max) : context.getString(mErrorId);
			}

			return null;
		}
	}

	public static class HasAlphaRule implements IRule
	{
		@StringRes
		private int mErrorId;

		public HasAlphaRule(@StringRes int errorId)
		{
			this.mErrorId = errorId;
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			if (value != null && StringUtils.isNotBlank(value))
			{
				for (char it : value.toCharArray())
				{
					if (Character.isLetter(it))
						return null;
				}
			}
			return context.getString(mErrorId);
		}
	}

	public static class OnlyDigitsRule implements IRule
	{
		@StringRes
		private int mErrorId;

		public OnlyDigitsRule(@StringRes int errorId)
		{
			this.mErrorId = errorId;
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			if (value != null && StringUtils.isNotBlank(value))
			{
				for (char it : value.toCharArray())
				{
					if (!Character.isDigit(it))
						return context.getString(mErrorId);
				}

				return null;
			}

			return context.getString(mErrorId);
		}
	}

	public static class PatternRule implements IRule
	{
		@NonNull
		private final Pattern mRegex;
		@StringRes
		private int mErrorId;

		public PatternRule(@NonNull String regex, @StringRes int errorId)
		{
			this.mErrorId = errorId;
			mRegex = Pattern.compile(regex);
		}

		@Nullable
		@Override
		public String validate(@NonNull Context context, @Nullable String value)
		{
			return value != null && mRegex.matcher(value).find() ? null : context.getString(mErrorId);
		}
	}

	public static class EmailRule extends PatternRule
	{
		private static final String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";

		public EmailRule(@StringRes int errorId)
		{
			super(EMAIL_PATTERN, errorId);
		}
	}
}
