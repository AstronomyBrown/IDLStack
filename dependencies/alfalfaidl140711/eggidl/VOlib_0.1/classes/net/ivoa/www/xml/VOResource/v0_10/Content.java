/**
 * Content.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class Content  implements java.io.Serializable {
    private java.lang.String[] subject;
    private java.lang.String description;
    private net.ivoa.www.xml.VOResource.v0_10.Source source;
    private org.apache.axis.types.URI referenceURL;
    private net.ivoa.www.xml.VOResource.v0_10.Type type;
    private net.ivoa.www.xml.VOResource.v0_10.ContentLevel[] contentLevel;
    private net.ivoa.www.xml.VOResource.v0_10.Relationship[] relationship;

    public Content() {
    }


    /**
     * Gets the subject value for this Content.
     * 
     * @return subject
     */
    public java.lang.String[] getSubject() {
        return subject;
    }


    /**
     * Sets the subject value for this Content.
     * 
     * @param subject
     */
    public void setSubject(java.lang.String[] subject) {
        this.subject = subject;
    }

    public java.lang.String getSubject(int i) {
        return this.subject[i];
    }

    public void setSubject(int i, java.lang.String value) {
        this.subject[i] = value;
    }


    /**
     * Gets the description value for this Content.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this Content.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the source value for this Content.
     * 
     * @return source
     */
    public net.ivoa.www.xml.VOResource.v0_10.Source getSource() {
        return source;
    }


    /**
     * Sets the source value for this Content.
     * 
     * @param source
     */
    public void setSource(net.ivoa.www.xml.VOResource.v0_10.Source source) {
        this.source = source;
    }


    /**
     * Gets the referenceURL value for this Content.
     * 
     * @return referenceURL
     */
    public org.apache.axis.types.URI getReferenceURL() {
        return referenceURL;
    }


    /**
     * Sets the referenceURL value for this Content.
     * 
     * @param referenceURL
     */
    public void setReferenceURL(org.apache.axis.types.URI referenceURL) {
        this.referenceURL = referenceURL;
    }


    /**
     * Gets the type value for this Content.
     * 
     * @return type
     */
    public net.ivoa.www.xml.VOResource.v0_10.Type getType() {
        return type;
    }


    /**
     * Sets the type value for this Content.
     * 
     * @param type
     */
    public void setType(net.ivoa.www.xml.VOResource.v0_10.Type type) {
        this.type = type;
    }


    /**
     * Gets the contentLevel value for this Content.
     * 
     * @return contentLevel
     */
    public net.ivoa.www.xml.VOResource.v0_10.ContentLevel[] getContentLevel() {
        return contentLevel;
    }


    /**
     * Sets the contentLevel value for this Content.
     * 
     * @param contentLevel
     */
    public void setContentLevel(net.ivoa.www.xml.VOResource.v0_10.ContentLevel[] contentLevel) {
        this.contentLevel = contentLevel;
    }

    public net.ivoa.www.xml.VOResource.v0_10.ContentLevel getContentLevel(int i) {
        return this.contentLevel[i];
    }

    public void setContentLevel(int i, net.ivoa.www.xml.VOResource.v0_10.ContentLevel value) {
        this.contentLevel[i] = value;
    }


    /**
     * Gets the relationship value for this Content.
     * 
     * @return relationship
     */
    public net.ivoa.www.xml.VOResource.v0_10.Relationship[] getRelationship() {
        return relationship;
    }


    /**
     * Sets the relationship value for this Content.
     * 
     * @param relationship
     */
    public void setRelationship(net.ivoa.www.xml.VOResource.v0_10.Relationship[] relationship) {
        this.relationship = relationship;
    }

    public net.ivoa.www.xml.VOResource.v0_10.Relationship getRelationship(int i) {
        return this.relationship[i];
    }

    public void setRelationship(int i, net.ivoa.www.xml.VOResource.v0_10.Relationship value) {
        this.relationship[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Content)) return false;
        Content other = (Content) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.subject==null && other.getSubject()==null) || 
             (this.subject!=null &&
              java.util.Arrays.equals(this.subject, other.getSubject()))) &&
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription()))) &&
            ((this.source==null && other.getSource()==null) || 
             (this.source!=null &&
              this.source.equals(other.getSource()))) &&
            ((this.referenceURL==null && other.getReferenceURL()==null) || 
             (this.referenceURL!=null &&
              this.referenceURL.equals(other.getReferenceURL()))) &&
            ((this.type==null && other.getType()==null) || 
             (this.type!=null &&
              this.type.equals(other.getType()))) &&
            ((this.contentLevel==null && other.getContentLevel()==null) || 
             (this.contentLevel!=null &&
              java.util.Arrays.equals(this.contentLevel, other.getContentLevel()))) &&
            ((this.relationship==null && other.getRelationship()==null) || 
             (this.relationship!=null &&
              java.util.Arrays.equals(this.relationship, other.getRelationship())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getSubject() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getSubject());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getSubject(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        if (getSource() != null) {
            _hashCode += getSource().hashCode();
        }
        if (getReferenceURL() != null) {
            _hashCode += getReferenceURL().hashCode();
        }
        if (getType() != null) {
            _hashCode += getType().hashCode();
        }
        if (getContentLevel() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getContentLevel());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getContentLevel(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getRelationship() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRelationship());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRelationship(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Content.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Content"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("subject");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "subject"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("source");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "source"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Source"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("referenceURL");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "referenceURL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyURI"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("type");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "type"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Type"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("contentLevel");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "contentLevel"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ContentLevel"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("relationship");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "relationship"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Relationship"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
