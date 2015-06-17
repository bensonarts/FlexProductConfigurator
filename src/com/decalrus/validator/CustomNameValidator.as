package com.decalrus.validator
{
	import mx.utils.StringUtil;
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;
	
	public class CustomNameValidator extends StringValidator
	{
		private var _excludedCharacters:String;
		private var _excludedCharacterNotAllowedError:String = "This field contains invalid character(s).";
		
		public function CustomNameValidator()
		{
			super();
		}
		
		public function get excludedCharacters():String
		{
			return this._excludedCharacters;
		}
		
		public function set excludedCharacters(value:String):void
		{
			value = StringUtil.trim(value);
			this._excludedCharacters = value;
		}
		
		public function get excludedCharacterNotAllowedError():String
		{
			return this._excludedCharacterNotAllowedError;
		}
		
		public function set excludedCharacterNotAllowedError(value:String):void
		{
			this._excludedCharacterNotAllowedError = value;
		}
		
		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value);
			
			var val:String = value ? String(value) : "";
			if (results.length > 0 || ((val.length == 0) && !required))
			{
				return results;
			}
			else
			{
				return CustomNameValidator.validateString(this, value, null);
			}
		}
		
		public static function validateString(validator:CustomNameValidator,
											  value:Object,
											  baseField:String = null):Array
		{
			var results:Array = [];
			
			// Resource-backed properties of the validator.
			var maxLength:Number = Number(validator.maxLength);
			var minLength:Number = Number(validator.minLength);
			
			var val:String = value != null ? String(value) : "";
			
			if (!isNaN(maxLength) && val.length > maxLength)
			{
				results.push(new ValidationResult(
					true, baseField, "tooLong",
					StringUtil.substitute(validator.tooLongError, maxLength)));
				return results;
			}
			
			if (!isNaN(minLength) && val.length < minLength)
			{
				results.push(new ValidationResult(
					true, baseField, "tooShort",
					StringUtil.substitute(validator.tooShortError, minLength)));
				return results;
			}
			
			var excludedCharsArr:Array = validator.excludedCharacters.split(",");
			if (excludedCharsArr != null && excludedCharsArr.length > 0)
			{
				for each(var excludedChar:String in excludedCharsArr)
				{
					excludedChar = StringUtil.trim(excludedChar);
					if (val.indexOf(excludedChar) > -1)
					{
						results.push(new ValidationResult(
							true, baseField, "excludedCharacterNotAllowedError",
							validator.excludedCharacterNotAllowedError + ' "' + excludedCharsArr.toString() + '"'));
					}
				}
			}
			
			return results;
		}
	}
	}
}